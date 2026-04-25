[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/yK93vo55)
# SE3011-Technical-Evolution-of-Multimedia-Lab05

# In-Class Lab — Processing: Animation Basics (Self-Guided)

**Duration:** 2 hours (120 minutes)  
**Goal:** By doing small tasks step-by-step, you will learn how animation works in Processing and finally build a small mini-game.

## What you’ll learn

You will learn how to:

- Use **`setup()`** (runs one time) and **`draw()`** (runs again and again)
- Move shapes using **variables** like `x` and `y`
- Control speed using **speed variables**
- Bounce objects by checking **screen edges**
- Move a player using **keyboard**
- Use **easing** (smooth follow movement)
- Use a **trail effect** (toggle ON/OFF)
- Use a **timer** and **game states** (Start / Play / End)
- Combine all into a **final game**

---

## Learning Outcomes (By the end you can…)

- Explain why `draw()` is used for animation  
- Move shapes using variables and speed  
- Bounce shapes using edge checks  
- Control objects using keyboard input  
- Create a mini interactive animation/game scene  

---

## Requirements

- Processing installed (any recent version)
- You can do this in **one sketch** (recommended for final), but for practice tasks you may create new sketches.

---

## Rules for this lab

1. Don’t copy from friends — try yourself first
2. After each activity, **Run it** and show to instructor/assistant
3. Save your work after each activity
4. If stuck: check spelling, brackets `{}`, and semicolons `;`

---

# Important Notes (Read Before Starting)

## 1) What is a “frame”?

Processing shows animation as a fast sequence of images, like a flipbook.  
Each image is called a **frame**.

## 2) Why `setup()` and `draw()`?

- `setup()` runs **only once** at the beginning.  
  We use it to set the window size (`size()`) and initial values.

- `draw()` runs **many times per second** (like 60 times).  
  We use it to update variables and redraw things.

## 3) Why do we use `background()` inside `draw()`?

When `draw()` runs again, the old drawing is still there unless we clear it.

- If you **clear** each frame → smooth animation (no trails)
- If you **don’t clear** → you see trails (old positions remain)

## 4) Coordinate system (very important)

- `(0, 0)` is **top left**
- `x` increases to the **right**
- `y` increases **downwards**
- `width` = screen width, `height` = screen height




---

# Activity 1  — Moving Dot (Your first animation)

## Goal
Make a small circle move from left to right.

## What you are learning here
- A variable can store a changing position.
- If we increase the position every frame, the object moves.

## Step-by-step instructions
1. Create a variable called `x` (horizontal position)
2. Create the window in `setup()`
3. In `draw()`:
   - clear the screen using `background()`
   - draw the circle at `(x, height/2)`
   - increase `x`

## Code (Type this)

```java
float x = 0;  // start at the left side

void setup() {
  size(700, 350); // window size (width, height)
}

void draw() {
  background(255);              // clears previous frame (255 = white)
  ellipse(x, height/2, 30, 30); // circle at (x, middle)
  x = x + 4;                    // move 4 pixels per frame
}
```


## Explanation

- `float x = 0;` → `x` is a number that can increase smoothly.
- `size(700, 350);` → creates the window.
- `background(255);` → clears old drawings.
- `ellipse(x, height/2, 30, 30);` → draws a circle in the middle.
- `x = x + 4;` → each frame, x increases → circle moves.

 **Check you got it right:**

- The dot moves to the right continuously.

### Mini Challenge (optional)

- Change `4` to `1` (slow) or `10` (fast)



---

# Activity 2 — Looping Motion + Trail Toggle

## Goal

1. When the dot goes off the right side, bring it back to the left.  
2. Add a trail effect ON/OFF using key `T`.

## What you are learning here

- **If conditions** check a rule.
- A **boolean** (`true/false`) can turn features ON/OFF.
- Trails happen when we *do not fully clear the screen.*

---

## Part A: Looping

### Idea
If the dot goes beyond the screen, reset x.

### Add this logic:
- If `x > width + radius`, then `x = -radius`

---

## Part B: Trails toggle

### Idea
- If trails OFF → use `background()`
- If trails ON → draw a transparent rectangle to fade slowly

---

## Full Code (Type this)

```java
float x = -15;
float speed = 4;
boolean trails = false;

void setup() {
  size(700, 350);
}

void draw() {
  if (!trails) {
    background(255); // normal clear
  } else {
    // fade layer: keeps trails but slowly fades them
    noStroke();
    fill(255, 35);          // white with transparency (alpha)
    rect(0, 0, width, height);
  }

  fill(50, 130, 240);
  ellipse(x, height/2, 30, 30);

  x += speed;

  if (x > width + 15) {
    x = -15;
  }

  fill(0);
  textSize(16);
  text("Trails: " + (trails ? "ON" : "OFF") + " (Press T)", 20, 25);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    trails = !trails; // switch true<->false
  }
}
```


## Explanation

- `boolean trails = false;` → feature OFF at start.
- `if (!trails)` means “if trails is false”.
- `fill(255, 35)` → 35 is alpha (transparency). Small alpha = slow fade.
- `keyPressed()` runs when a key is pressed.
- `trails = !trails;` flips the value (false → true, true → false).

 **Check**

- Dot loops from left again when it goes out.
- Press **T** → trails appear/disappear.

---

# Activity 3 — 2D Bouncing Orb + Speed Control (+ / -)

## Goal

Make a ball bounce around the window in **both x and y** directions.  
Also let the user increase/decrease speed using `+` and `-`.

## What you are learning

- Movement in 2D = change x **AND** y.
- Speed in 2D = `xs` and `ys`.
- Bounce happens by reversing direction: multiply by `-1`.
- Boundary check must consider **radius**.

---

## Code

```java
float x = 100, y = 100;
float xs = 4, ys = 3;
float r = 20;

void setup() {
  size(700, 350);
}

void draw() {
  background(245);

  // move
  x += xs;
  y += ys;

  // bounce with radius logic
  if (x > width - r || x < r) xs *= -1;
  if (y > height - r || y < r) ys *= -1;

  fill(255, 120, 80);
  ellipse(x, y, r*2, r*2);

  fill(0);
  textSize(16);
  text("Press + to speed up | - to slow down", 20, 25);
}

void keyPressed() {
  if (key == '+') { xs *= 1.2; ys *= 1.2; }
  if (key == '-') { xs *= 0.8; ys *= 0.8; }
}
```

## Explanation

- `xs` = x speed. If positive → moves right. If negative → moves left.
- `ys` = y speed. If positive → moves down. If negative → moves up.
- `xs *= -1;` means reverse direction.
- We use `width - r` so the ball edge doesn’t go out of screen.

 **Check**

- Orb bounces on all walls
- `+` makes it faster, `-` makes it slower

---

# Activity 4 — Keyboard Controlled Player (Arrow keys)

## Goal

Create a player that moves with arrow keys, and stays inside the screen.

## Code

```java
float px = 350, py = 175;
float step = 6;
float pr = 20;

void setup() {
  size(700, 350);
}

void draw() {
  background(240);

  if (keyPressed) {
    if (keyCode == RIGHT) px += step;
    if (keyCode == LEFT)  px -= step;
    if (keyCode == DOWN)  py += step;
    if (keyCode == UP)    py -= step;
  }

  px = constrain(px, pr, width - pr);
  py = constrain(py, pr, height - pr);

  fill(60, 120, 200);
  ellipse(px, py, pr*2, pr*2);
}
```
## Explanation

- `keyPressed` is true when any key is held.
- `keyCode` checks arrow keys.
- `constrain(value, min, max)` keeps it in range.

 **Check:**

- Player moves in all 4 directions
- Never goes outside the window

---

# Activity 5 — Helper Dot Follows Player Using Easing

## Goal

Create a helper dot that follows the player smoothly.

## Why easing?

If helper jumps instantly, it looks robotic. Easing makes it smoother.

### Easing formula

`hx = hx + (target - hx) * ease;`

That means: move a small percentage of the distance each frame.

## Code

```java
float px = 350, py = 175;
float step = 6;
float pr = 20;

float hx, hy;      // helper position
float ease = 0.10; // easing factor (0.0 to 1.0)

void setup() {
  size(700, 350);
  hx = px; // start helper at player position
  hy = py;
}

void draw() {
  background(255);

  // player control
  if (keyPressed) {
    if (keyCode == RIGHT) px += step;
    if (keyCode == LEFT)  px -= step;
    if (keyCode == DOWN)  py += step;
    if (keyCode == UP)    py -= step;
  }

  // keep player inside the screen
  px = constrain(px, pr, width - pr);
  py = constrain(py, pr, height - pr);

  // easing follow (helper moves part of the distance each frame)
  hx = hx + (px - hx) * ease;
  hy = hy + (py - hy) * ease;

  // draw player
  fill(60, 120, 200);
  ellipse(px, py, pr*2, pr*2);

  // draw helper
  fill(80, 200, 120);
  ellipse(hx, hy, 16, 16);

  // label
  fill(0);
  text("Helper follows using easing", 20, 25);
}
```

## Explanation

 **Check:**

- Helper follows smoothly, not instantly.

---

# Activity 6 — Timer + Game States (Start / Play / End)

## Goal

Show different screens based on `state`.

## What are “states”?

A **state** is like a mode:

- Start screen  
- Playing screen  
- End screen  

## Code

```java
int state = 0; // 0=start, 1=play, 2=end
int startTime;
int duration = 20; // seconds

void setup() {
  size(700, 350);
}

void draw() {
  background(245);

  // START screen
  if (state == 0) {
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Press ENTER to Start", width/2, height/2);
  }

  // PLAY screen (timer runs)
  if (state == 1) {
    int elapsed = (millis() - startTime) / 1000; // convert ms to seconds
    int left = duration - elapsed;

    textAlign(LEFT, TOP);
    textSize(18);
    fill(0);
    text("Time Left: " + left, 20, 20);

    if (left <= 0) {
      state = 2; // go to END screen
    }
  }

  // END screen
  if (state == 2) {
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(0);
    text("Time Over! Press R to Reset", width/2, height/2);
  }
}

void keyPressed() {
  // press ENTER to start playing
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis(); // remember the start time
  }

  // press R to reset back to start screen
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0;
  }
}
```

## Explanation

 **Check:**

- ENTER starts  
- Timer counts down  
- End screen appears  
- R resets  

---

# FINAL TASK — Catch the Orb (Enhanced 2-Hour Version)

## Goal (What you must build)

A mini game with:

- Start screen (ENTER)  
- Player moves with arrow keys  
- Orb bounces  
- When player touches orb → score increases + orb resets randomly  
- Orb speed increases slightly each catch  
- Helper follows using easing  
- Trails toggle (T)  
- 30-second timer  
- End screen shows final score, press R to restart  

*(You already learned every part above. Now you combine them.)*

---

## Final Task Extensions(If you finish early) — pick TWO

1) Add a **second orb** with different speed (**+1 score**)  
2) Add a **gold orb** every 5 catches (**+3 score**)  
3) Add **sound** on catch (if available)  
4) Add an **obstacle box** in the middle (player cannot pass through)

---

## Submission

- Final `.pde` file  
- Screenshots: **Start screen** + **Playing screen** + **End screen** (score visible)




---

##  Good Luck & Enjoy Coding!

```text
   ⭐     ⭐       ⭐
        ⭐     ⭐
   ⭐           ⭐

      GOOD LUCK!
   🚀 Keep Animating 🚀

   ⭐           ⭐
        ⭐     ⭐
   ⭐     ⭐       ⭐
```

✨ **You made it to the end of the lab!**  
Keep experimenting, try new ideas, and most importantly — **have fun with animation and creativity.**

💡 Remember:
- Small changes create big animations  
- Practice makes you faster  
- Creativity makes your work unique  

**Happy Coding! 🚀**
