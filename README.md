# Hello, API ★ i.c.stars

**In 30 minutes: build "Who's That Pokémon?" out of data you never typed.**

One game, three passes — **I do → We do → You do.**

| | |
|---|---|
| **Who** | Complete beginners. If you can write `<h1>Hi</h1>`, you're ready. |
| **Time** | 30 minutes |
| **You need** | A browser, [VS Code](https://code.visualstudio.com/), [Postman](https://www.postman.com/downloads/) |
| **You do NOT need** | A server, a database, npm, a login, a credit card |
| **Next** | React — and the `fetch` you learn tonight doesn't change. See [React changes less than you think](#react-changes-less-than-you-think). |

> 📊 **Teaching this?** Project [`REF-week6-api-tutorial-deck.html`](REF-week6-api-tutorial-deck.html) —
> 16 slides in the house deck template, with **three live demos running inside the slides** —
> you never leave the deck to show the code working. Arrow keys or tap the screen edges;
> **Ctrl+P → Save as PDF** exports one slide per page.

---

## Get it on your laptop

```
git clone https://github.com/icstars-milwaukee/icstars-rfp-molson-cycle21-carl-.git
cd icstars-rfp-molson-cycle21-carl-
```

Then right-click `index.html` → **Open with Live Server** in VS Code.
Or just read it in the browser: **https://icstars-milwaukee.github.io/icstars-rfp-molson-cycle21-carl-/**

---

## The three passes

| Pass | File | What's new |
|---|---|---|
| **I do** | [`step-1-i-do.html`](step-1-i-do.html) | The three lines. One Pokémon, name + picture. |
| **We do** | [`step-2-we-do.html`](step-2-we-do.html) | A **list** of 151 → pick one at random → hide it. |
| **You do** | [`step-3-you-do.html`](step-3-you-do.html) | Four guess buttons + a score. **Now it's a game.** |
| *finished* | [`game.html`](game.html) | Score, streak, keyboard `1-4`, loading + error states. |

---

## The whole idea in one picture

```
   YOU            YOUR PAGE                      THE API
  click  ─────►  fetch(url) ───  GET /pokemon ──►  another
                     ▲                             computer
                     └───  JSON + 200 OK  ◄────────┘
                     │
                     ▼
            Pikachu on the page
```

An **API** is a URL you can ask for data instead of a web page. That's the concept.

---

## The only 4 words you need

| Word | Plain English | Tonight's example |
|---|---|---|
| **API** | A computer that hands out data when you ask | `pokeapi.co` |
| **Endpoint** | One specific URL on it | `/pokemon/25` gives one, `/pokemon?limit=151` gives a list |
| **JSON** | How data is written down while it travels | `{ "name": "pikachu" }` |
| **Status code** | Did it work? | `200` yes · `404` no such thing · `500` their fault |

> REST, HTTP verbs, headers, auth tokens, rate limits — **all of it can wait.**

**Reading JSON:** `{ }` is one thing · `[ ]` is a list · a dot means "go inside".
**Brackets mean you can loop it, count it, and pick from it at random** — which is why a game is
possible tonight.

---

## The three lines. Everything else is decoration.

```js
const response = await fetch(API_URL);     // 1. ASK    — go get it
const pokemon  = await response.json();    // 2. UNWRAP — make it usable
output.textContent = pokemon.name;         // 3. SHOW   — put it on the page
```

| Word | What it actually means |
|---|---|
| `async` | *"There's a wait inside this function."* Goes before `function`. |
| `await` | *"Pause here until the data arrives."* Goes before `fetch` **and** `.json()`. |

`response` is a **sealed envelope** — the status code is printed on the outside.
`.json()` opens it. That's why it takes two steps, not one.

---

## Part 0 · Postman first — see it before you code it

If you write JavaScript before you've seen the data, you're debugging your typing **and**
guessing the data's shape at once. Postman removes one of those.

1. Open Postman → **skip the sign-in** (*Continue without an account*)
2. **New** → **HTTP Request**, leave the method on **GET**
3. Paste `https://pokeapi.co/api/v2/pokemon/25` → **Send**

```
Status: 200 OK
{
    "id": 25,
    "name": "pikachu",                 ← we'll put this on the page
    "weight": 60,
    "sprites": {
        "front_default": "https://.../sprites/pokemon/25.png"
    }                                  ← nested! pokemon.sprites.front_default
}
```

Then try these two:

| URL | What changes |
|---|---|
| `/pokemon?limit=151` | A **list** — `[ ]` inside a `results` field. 151 of them. |
| `/pokemon/99999` | **`404 Not Found`** — on purpose. Break it while it's safe. |

> ✅ **Checkpoint:** everybody has seen a `200` and a `404` before writing any code.

---

## Part 1 · I DO — watch me

**File:** [`step-1-i-do.html`](step-1-i-do.html) · **the code you edit live:** [`js/step-1.js`](js/step-1.js)

> 🎬 **Instructor:** `js/step-1.js` has four banner-marked spots — **EDIT 1** the URL, **EDIT 2** the two `fetch` lines, **EDIT 3** the text, **EDIT 4** the picture. Type them in that order, refreshing between each, and the page assembles itself in front of the room.

Hands off keyboards. One button → one Pokémon → its name, weight, type, **and its picture**
on the page.

The picture is the moment worth pausing on: it's just a field holding a URL, handed to an `<img>`.

```js
sprite.src = pokemon.sprites.front_default;   // two dots = two levels in
```

> ⚠️ Forget `await` and you get `Promise { <pending> }` instead of your data. That's the
> #1 beginner bug, and now you've seen it before it happened to you.

---

## Part 2 · WE DO — together

**File:** [`step-2-we-do.html`](step-2-we-do.html)

Same three lines, new URL — this one returns a **list of 151**. So now we can pick one at
random and hide it.

```js
const response = await fetch("https://pokeapi.co/api/v2/pokemon?limit=151");
const data     = await response.json();
allPokemon     = data.results;        // 151 of them, in [ ]

// Math.random() gives 0-to-1. Times the length, rounded down, = a random slot.
mystery = allPokemon[Math.floor(Math.random() * allPokemon.length)];

const id = mystery.url.split("/")[6];        // ".../pokemon/25/" → "25"
sprite.src = SPRITE_BASE + id + ".png";
sprite.classList.add("hidden");              // CSS: filter: brightness(0)
```

**`brightness(0)` paints every pixel black.** That's the entire silhouette effect — one line of
CSS, no image editing. Clicking **Reveal** just removes the class.

> ✅ **Checkpoint:** a black silhouette, and Reveal shows who it is.

---

## Part 3 · YOU DO — make it a game 🎮

**File:** [`step-3-you-do.html`](step-3-you-do.html)

A mystery you can only *look at* isn't a game. Add **four buttons and a score** and it is.

| TODO | Your job |
|---|---|
| **1** | Write the two `fetch` lines — third time tonight, you've got this |
| **2** | Loop the four choices into four buttons (the shape is in step 2) |
| **3** | Right or wrong? Add to the score and colour the button |

The decoy-picking, the silhouette, and the "grey out every button" part are already written —
**the three TODOs are the game itself.**

> **A game is just data + a random pick + a click handler.** That's the whole trick.

Stuck? [`step-3-you-do-solution.html`](step-3-you-do-solution.html) — but try for five minutes first.
Press **F12** → Console to read your errors.

> 🔥 **Done early?** Change `151` to `1351` and meet every Pokémon there is. Or add a timer.
> Or a streak counter. Or two sprites and a "which one is heavier" round.

---

## Part 4 · The finished game

**File:** [`game.html`](game.html) — all the logic in [`js/game.js`](js/game.js)

Markup in `game.html`, styles in `css/`, logic in `js/` — the way real sites are built.

Everything from Parts 1–3, plus the four things that make it real:

| Feature | Why a real site needs it |
|---|---|
| Loads on open | No "click me" button. Real sites just load. |
| Keeps score | Score, streak, personal best — and keys **1–4** to play fast |
| Loading message | The user waits 200ms. Tell them something's happening. |
| Error message | Wifi dies, API goes down. Don't show a blank page. |

**The one rule in `js/game.js`:** change `state`, then call `render()`. Never edit the page directly.
That's exactly the habit React requires, so practising it tonight is free.

> ⚠️ `fetch()` does **not** throw on a `404` or `500`. You have to check `response.ok`
> yourself — see the `try / catch` in `js/game.js`. The API answered; the answer was just "no".

---

## React changes less than you think

| What you wrote tonight | In React | Changes? |
|---|---|---|
| `choices.forEach(...)` | `choices.map(c => <Choice ... />)` | Same loop |
| Calling `render()` yourself | React does it **for you** | You delete it 🎉 |
| `fetch` / `await` / `.json()` | **Identical** | ❌ Nothing |
| `const state = { }` | `useState()` | New syntax |
| `load()` on page open | `useEffect(() => { ... }, [])` | New wrapper |
| `class="ics-choice"` | `className="ics-choice"` | One word |

**React is not a new way to get data. It's a tidier way to put data on the page.**

---

## Homework — Pluralsight

Pick **one** and finish it. One finished course beats five abandoned ones.

| Priority | Course |
|---|---|
| 🥇 **Start here** | [React Fundamentals](https://www.pluralsight.com/courses/react-18-fundamentals) *(or the [React 18 path](https://www.pluralsight.com/paths/react-18))* |
| 🥈 Shaky on JS? | [JavaScript: Getting Started](https://www.pluralsight.com/courses/javascript-getting-started) — Mark Zamoyta, 4h |
| 🥉 Confused by `await`? | [JavaScript Promises and Async Programming](https://www.pluralsight.com/courses/javascript-promises-async-programming) |
| 🧪 Learn by doing? | [Guided: APIs in JavaScript](https://www.pluralsight.com/labs/codeLabs/guided-apis-in-javascript) *(hands-on lab)* |

> Pluralsight renames courses often. If a link 404s, search the **title** — you know what a 404 is now.

**Free alternatives:** [MDN: Using Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch)
· [react.dev Quick Start](https://react.dev/learn)

**More practice:** [`extra-practice-posts.html`](extra-practice-posts.html) — a **different API**
entirely, same three lines ([solution](extra-practice-posts-solution.html)). Proof that the move
transfers.

---

## When it breaks

| The screen says | What's wrong | Fix |
|---|---|---|
| `Promise { <pending> }` | Missing `await` | Add it before `fetch` **and** before `.json()` |
| `Cannot read properties of undefined` | Wrong field name, or nesting skipped | Is it `sprites.front_default`? Check in Postman |
| `await is only valid in async functions` | Missing `async` | Add `async` before `function` |
| A broken-image icon | The sprite URL is wrong | Check the `id` you pulled out of the url |
| Blank page, no error | Script ran before the HTML existed | `<script>` must be **last** before `</body>` |
| Nothing happens on click | `id` mismatch | It must match `getElementById` **exactly** — case-sensitive |

**Your debugging tool is F12.** Console tab. Read the red text — it names the problem and the line.

---

## Files in this repo

```
.   (the repo root)
├── index.html                        ← start here (links everything)
├── REF-week6-api-tutorial-deck.html  ← the deck to project (self-contained)
├── README.md
│
├── css/
│   ├── theme.css                     ← the i.c.stars theme — every page uses it
│   └── game.css                      ← a few extras for the finished game
│
├── js/
│   ├── step-1.js                     ← I DO   · marked EDIT 1-4 for the live demo
│   ├── step-2.js                     ← WE DO  · list + random + silhouette
│   ├── step-3.js                     ← YOU DO · 3 TODOs
│   ├── step-3-solution.js            ← answer key
│   ├── game.js                       ← the finished game: state → render → load
│   ├── extra-practice.js
│   └── extra-practice-solution.js
│
├── step-1-i-do.html                  ← each page is markup only...
├── step-2-we-do.html                 ←   ...and loads one file from js/
├── step-3-you-do.html
├── step-3-you-do-solution.html
├── game.html
├── extra-practice-posts.html
└── extra-practice-posts-solution.html
```

**Opening the files:** double-clicking works. But install the **Live Server** extension in
VS Code and use *Right-click → Open with Live Server* — the page reloads every time you save.

---

★ *Sample data from [PokeAPI](https://pokeapi.co/) and
[JSONPlaceholder](https://jsonplaceholder.typicode.com/) — both free, no key, no signup.
Borrowing someone else's data is the whole point: you'll do it every day of your career.*
