/**
 * YARALMA Phase 4: WhatsApp webhook for Twilio.
 * POST from Twilio with Body (message) and From (E.164 phone).
 * Commands: LOCK → set is_locked = true for profile with matching whatsapp_phone
 *           UNLOCK → set is_locked = false
 * Requires Vercel env: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
 */

const { createClient } = require('@supabase/supabase-js');

function normalizePhone(from) {
  if (!from || typeof from !== 'string') return '';
  // Twilio WhatsApp sends "whatsapp:+221771234567" — keep digits only for DB match
  return from.replace(/\D/g, '').trim();
}

function twimlReply(text) {
  return `<?xml version="1.0" encoding="UTF-8"?><Response><Message>${escapeXml(text)}</Message></Response>`;
}

function escapeXml(s) {
  if (s == null) return '';
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;');
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).setHeader('Content-Type', 'text/plain').end('Method Not Allowed');
    return;
  }

  const url = process.env.SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!url || !serviceKey) {
    console.error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY');
    res.status(500).setHeader('Content-Type', 'text/xml').end(twimlReply('Service configuration error.'));
    return;
  }

  const body = req.body || {};
  const from = body.From || body.from || '';
  const messageBody = (body.Body || body.body || '').trim().toUpperCase();
  const phone = normalizePhone(from);

  if (!phone) {
    res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('No sender number.'));
    return;
  }

  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  // Match whatsapp_phone as digits-only or E.164 (+digits)
  const phoneE164 = phone.startsWith('+') ? phone : '+' + phone;

  if (messageBody === 'LOCK') {
    const { data: profile, error: findErr } = await supabase.from('profiles').select('id').or(`whatsapp_phone.eq.${phone},whatsapp_phone.eq.${phoneE164}`).limit(1).maybeSingle();
    if (findErr) {
      console.error('Supabase select error:', findErr);
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Error updating lock.'));
      return;
    }
    if (!profile) {
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('This number is not linked. Add it in YARALMA app.'));
      return;
    }
    const { error } = await supabase.from('profiles').update({ is_locked: true, updated_at: new Date().toISOString() }).eq('id', profile.id);
    if (error) {
      console.error('Supabase update error:', error);
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Error updating lock.'));
      return;
    }
    res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Screens locked.'));
    return;
  }

  if (messageBody === 'UNLOCK') {
    const { data: profile, error: findErr } = await supabase.from('profiles').select('id').or(`whatsapp_phone.eq.${phone},whatsapp_phone.eq.${phoneE164}`).limit(1).maybeSingle();
    if (findErr) {
      console.error('Supabase select error:', findErr);
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Error updating lock.'));
      return;
    }
    if (!profile) {
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('This number is not linked.'));
      return;
    }
    const { error } = await supabase.from('profiles').update({ is_locked: false, updated_at: new Date().toISOString() }).eq('id', profile.id);

    if (error) {
      console.error('Supabase update error:', error);
      res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Error updating lock.'));
      return;
    }
    res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Screens unlocked.'));
    return;
  }

  res.status(200).setHeader('Content-Type', 'text/xml').end(twimlReply('Send LOCK or UNLOCK.'));
};
