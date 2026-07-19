# Íslenska 🌌

**Learn Icelandic the fun way — a free, gamified PWA (A1–C2), in Czech and English.**

👉 **Live app: [vojta42.github.io/nordurljos](https://vojta42.github.io/nordurljos/)**

Íslenska is a personal, strictly **non-profit** hobby project. It was built primarily for the author himself, his family and friends — but anyone is welcome to use it.

## Features

- 📚 **56 lessons across six levels (A1–C2)** — from greetings and numbers all the way to the subjunctive, sagas, proverbs and slang
- 🧭 **Placement test** that starts you at the right level
- 🎮 **Gamification** — XP, daily goals, streaks, hearts, stars, badges, answer combos and three random daily quests
- ✏️ **Varied exercises** — multiple choice, fill-in-the-blank, sentence building, pair matching and typed answers (with a tolerant check for Icelandic diacritics and an on-screen `á é í ó ú ý ð þ æ ö` keypad)
- 🧠 **Smart word learning** — new words are introduced visually first; spelling is only required after you have met a word a couple of times, and weak words come back in practice sessions
- 🏆 **Private friends leaderboard** — create a group, share a secret code, and race your friends in a weekly XP contest; no global leaderboard, no public data
- 🌐 **Czech and English interface** — including all lesson content
- 📱 **Installable PWA** — works offline, installs to the home screen on Android (Chrome → *Add to Home Screen*)
- 🔒 **Privacy-friendly** — progress lives in your browser (with JSON export/import); the optional leaderboard shares only a nickname, XP, streak and lesson count; usage statistics are fully anonymous counters

## Tech

- A single self-contained `index.html` — vanilla JavaScript, no framework, no build step
- Hosted on **GitHub Pages**, offline support via a service worker
- Optional backend on **Supabase** (leaderboard + anonymous stats): tables are locked down with RLS, all access goes through `SECURITY DEFINER` RPC functions — see the `supabase*.sql` files

## Running locally

No build needed — just open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000
# → http://localhost:8000
```

## Feedback

Notes, suggestions for improvement — and even compliments 🙂 — are welcome at **vojta.luhan(at)seznam.cz**.

## Disclaimer

The app is developed with the help of **Claude** (an AI by Anthropic), but to the best of the author's knowledge and conscience. As far as the author is aware, it contains no known errors — however, **it is provided as-is, with no guarantees of any kind**.

## License

[MIT](LICENSE) © Vojta Luhan

---

<details>
<summary>🇨🇿 Česky</summary>

**Íslenska** je gamifikovaná webová aplikace na výuku islandštiny (úrovně A1–C2, česky i anglicky). Jde o absolutně neziskový soukromý projekt — vznikl primárně pro autora, jeho rodinu a kamarády, ale používat ji může kdokoli: **[vojta42.github.io/nordurljos](https://vojta42.github.io/nordurljos/)**.

Poznámky, návrhy na zlepšení i pochvaly posílejte na **vojta.luhan(at)seznam.cz**. Aplikace je vytvářena za pomoci Clauda, ale podle nejlepšího vědomí a svědomí autora; neobsahuje žádné chyby, o kterých by autor věděl, ale **za nic neručí**. Zveřejněno pod licencí MIT.

</details>
