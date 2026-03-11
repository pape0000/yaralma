prd.md
PRD - YARALMA: The Senegalese Value-Based Digital Shield
Status: Draft / MVP Definition
Target Market: All Senegalese
Target Audience: Parents of children aged 3–12
1. Product Vision & Goals
Vision: To encode the six pillars of Senegalese ancestral values (Teranga, Jom, Kersa, Sutura, Muñ, Ngor) into the digital tools of the future.
Goals:
Provide a "Cultural Sovereignty" layer over global platforms (YouTube/Netflix).
Reduce parent-child conflict through automated, value-based scheduling.
Bridge the linguistic gap by filtering harmful content in Wolof and local French.
Enable spiritual discipline through automatic sync with prayer times and Sunday Mass.
2. Problem Statement
Senegalese parents currently face a "Digital Value Gap":
Western-Centric Tools: Existing parental controls do not understand Senegalese taboos or religious rhythms.
The Algorithm Trap: YouTube/Netflix recommendation engines often surface content that violates Kersa (modesty) or Jom (dignity).
Linguistic Blindness: Global AI ignores Wolof-language profanity and disrespectful rhetoric towards local elders and religious figures.
3. Target Audience & User Personas
3.1 Demba (The Muslim Parent)
Context: Merchant in Pikine, Mouride follower.
Pain Point: Worry that the family tablet exposes his son, Pathé (10), to content that undermines their religious education.
3.2 Joseph (The Christian Parent)
Context: Civil servant in Ziguinchor, Catholic.
Pain Point: Concerns that Marie (10) is being influenced by foreign lifestyle trends that clash with local integrity (Ngor).
3.3 The Child (Pathé/Marie)
Age Range: 3–12 years old.
Behavior: Heavy users of YouTube (Cartoons, Football, Senegalese series) and Netflix (Series).
4. Product Scope
4.1 In-Scope (MVP)
Android Accessibility Overlay: Real-time visual blurring and audio muting on top of YouTube/Netflix apps.
Account Linking: OAuth for YouTube and Google (parent-linked account; Family Link–style experience via our overlay — Google does not provide a public Family Link API).
Spiritual Sync: Location-based locks for Islamic prayer and Sunday Mass.
WhatsApp Dashboard: Weekly reports and remote command triggers (LOCK, +30min).
Multi-Lingual UI: Setup and alerts in French, Wolof, and Diola.
4.2 Out-of-Scope
Social Media: No filtering for TikTok, Instagram, or Snapchat in V1.
Browser-Wide Filtering: Only protects the official YouTube/Netflix apps.
Hardware: No physical routers or modified hardware.
Granular Surveillance: No tracking of private messages or specific video history (respecting Sutura).
5. Functional Requirements
5.1 Onboarding & Faith Configuration
[FR-01] Users must complete a "Value Agreement" (6 Pillars) before entering settings.
[FR-02] Users select a Faith Shield (Mouride, Tijaniyya, General Muslim, or Christian).
[FR-03] Guided setup for Android Accessibility permissions to enable the "Overlay."
5.2 The YouTube Guardian (API + Overlay)
[FR-04] Automated removal of the "Shorts" shelf via API.
[FR-05] Search bar interception: Clearing queries containing blocked Wolof/French keywords.
[FR-06] "Explore Mode" enforcement (Age 9-12) or "YouTube Kids" enforcement (Age 3-8).
5.3 The Netflix Overlay (Visual Shield)
[FR-07] Real-time blur of scenes based on community-sourced timestamps (The "Lion Guardian" list).
[FR-08] Hiding of specific thumbnails in the Netflix catalog flagged as violating Kersa.
5.4 The "Holy Lock" Mechanism
[FR-09] Full-screen lock during 5 daily prayer times (calculated by GPS location).
[FR-10] Sunday morning lock (08:00 AM - 11:30 AM) for Christian profiles.
[FR-11] "Ramadan Mode" & "Lent Mode" automatic schedule adjustments.
5.5 WhatsApp Integration
[FR-12] Automated Sunday morning summary (The "Jom Report").
[FR-13] Remote locking/unlocking via WhatsApp command bot.
6. Technical Requirements
Frontend: Flutter for the parent setup app.
Background Service: Android Accessibility Service (Kotlin/Java) for the system-wide overlay.
Cloud Backend: Supabase for real-time config sync and user profiles.
Messaging: Twilio WhatsApp Business API.
Prayer Times: Free API by location (e.g. Aladhan API or IslamicAPI) for Islamic prayer times; store API key in Supabase config or env if required.
ASR (Speech-to-Text): Specialized Wolof acoustic model for real-time audio keyword detection.
7. Success Metrics (KPIs)
Conversion: % of users who complete the "Account Link" in under 5 minutes.
Filter Accuracy: % of inappropriate Wolof dialogue correctly muted.
Behavioral Impact: % of families reporting a decrease in "screen-time arguments" due to the automatic Lock.
Retention: % of users who renew the "Faith Shield" during Ramadan/Lent.
8. User Experience (UX) Principles
The Silent Lion: Protection should be discreet. Blurs over alarms.
Sutura First: Protect the child's dignity by never "shaming" them in front of the parent.
Teranga Design: A warm, premium interface that feels like a gift to the family, not a digital prison.
9. Future Roadmap
V2: Extension to TikTok and Reels.
V3: "Zero-Rated" data partnership with Orange/Free Senegal.
V4: Transition to a fully offline "Privacy-First" AI model.