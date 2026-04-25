int state = 0;       // 0=start, 1=play, 2=end
int startTime;
int gameDuration = 30;
int score = 0;
boolean trails = false;

// --- Player ---
float px, py;
float pStep = 5;
float pr = 18;

// --- Easing Helper ---
float hx, hy;
float ease = 0.10;

// --- Orb 1 (main) ---
float ox, oy;
float oxs = 4, oys = 3;
float or_ = 16;
int orbCatches = 0;

// --- Orb 2 (extension) ---
float ox2, oy2;
float ox2s = -3.5, oy2s = 2.5;
float or2 = 12;

// --- Gold Orb (every 5 catches, +3 score) ---
float gox, goy;
float goxs = 3, goys = -2.5;
float gor = 14;
boolean goldActive = false;
int goldStartTime = 0;
int goldDuration = 8000; // disappears after 8 seconds

void setup() {
  size(700, 350);
  textFont(createFont("Arial Bold", 16));
  resetPositions();
}

void resetPositions() {
  px = width / 2;
  py = height / 2;
  hx = px; hy = py;
  ox = 100; oy = 80;
  ox2 = 500; oy2 = 250;
  gox = 300; goy = 150;
}

void draw() {
  // --- Trail / Clear ---
  if (state == 1 && trails) {
    noStroke();
    fill(245, 40);
    rect(0, 0, width, height);
  } else {
    background(245);
  }

  if (state == 0) drawStartScreen();
  if (state == 1) drawGame();
  if (state == 2) drawEndScreen();
}

void drawStartScreen() {
  textAlign(CENTER, CENTER);
  fill(30, 80, 200);
  textSize(30);
  text("CATCH THE ORB", width/2, height/2 - 60);

  fill(60);
  textSize(16);
  text("Arrow Keys → Move Player", width/2, height/2 - 10);
  text("T → Toggle Trails", width/2, height/2 + 20);
  text("+ / -  → Speed Up / Down", width/2, height/2 + 50);

  fill(30, 150, 80);
  textSize(20);
  text("Press ENTER to Start", width/2, height/2 + 100);
}

void drawGame() {
  // Timer check
  int elapsed = (millis() - startTime) / 1000;
  int timeLeft = gameDuration - elapsed;
  if (timeLeft <= 0) {
    state = 2;
    return;
  }

  // ── Player movement ──
  if (keyPressed) {
    if (keyCode == RIGHT) px += pStep;
    if (keyCode == LEFT)  px -= pStep;
    if (keyCode == DOWN)  py += pStep;
    if (keyCode == UP)    py -= pStep;
  }
  px = constrain(px, pr, width - pr);
  py = constrain(py, pr, height - pr);

  // ── Easing helper ──
  hx = hx + (px - hx) * ease;
  hy = hy + (py - hy) * ease;

  // ── Orb 1 move + bounce ──
  ox += oxs;
  oy += oys;
  if (ox > width - or_ || ox < or_)  oxs *= -1;
  if (oy > height - or_ || oy < or_) oys *= -1;
  ox = constrain(ox, or_, width - or_);
  oy = constrain(oy, or_, height - or_);

  // Orb 1 catch
  if (dist(px, py, ox, oy) < pr + or_) {
    score += 1;
    orbCatches++;
    // Speed up slightly each catch
    float boost = min(1.15, 1.0 + orbCatches * 0.015);
    oxs *= boost;
    oys *= boost;
    // Respawn orb
    ox = random(or_, width - or_);
    oy = random(or_, height - or_);
    // Every 5 catches → spawn gold orb
    if (orbCatches % 5 == 0) {
      goldActive = true;
      goldStartTime = millis();
      gox = random(gor, width - gor);
      goy = random(gor, height - gor);
      goxs = random(2, 4) * (random(1) > 0.5 ? 1 : -1);
      goys = random(2, 3.5) * (random(1) > 0.5 ? 1 : -1);
    }
  }

  // ── Orb 2 move + bounce ──
  ox2 += ox2s;
  oy2 += oy2s;
  if (ox2 > width - or2 || ox2 < or2)  ox2s *= -1;
  if (oy2 > height - or2 || oy2 < or2) oy2s *= -1;
  ox2 = constrain(ox2, or2, width - or2);
  oy2 = constrain(oy2, or2, height - or2);

  // Orb 2 catch
  if (dist(px, py, ox2, oy2) < pr + or2) {
    score += 1;
    ox2 = random(or2, width - or2);
    oy2 = random(or2, height - or2);
  }

  // ── Gold Orb move + bounce ──
  if (goldActive) {
    gox += goxs;
    goy += goys;
    if (gox > width - gor || gox < gor)  goxs *= -1;
    if (goy > height - gor || goy < gor) goys *= -1;
    gox = constrain(gox, gor, width - gor);
    goy = constrain(goy, gor, height - gor);

    // Gold orb expires
    if (millis() - goldStartTime > goldDuration) goldActive = false;

    // Gold orb catch
    if (dist(px, py, gox, goy) < pr + gor) {
      score += 3;
      goldActive = false;
    }
  }


  // Helper line (dashed look)
  stroke(100, 200, 100, 80);
  strokeWeight(1);
  line(px, py, hx, hy);
  noStroke();

  // Helper dot
  fill(80, 200, 120);
  ellipse(hx, hy, 14, 14);

  // Orb 1 (blue)
  fill(50, 130, 240);
  noStroke();
  ellipse(ox, oy, or_*2, or_*2);

  // Orb 2 (purple)
  fill(160, 80, 220);
  ellipse(ox2, oy2, or2*2, or2*2);

  // Gold orb (with +3 label)
  if (goldActive) {
    float fadeAlpha = map(millis() - goldStartTime, 0, goldDuration, 255, 60);
    fill(255, 200, 0, fadeAlpha);
    ellipse(gox, goy, gor*2, gor*2);
    fill(0, fadeAlpha);
    textAlign(CENTER, CENTER);
    textSize(11);
    text("+3", gox, goy - gor - 7);
  }

  // Player (outlined circle)
  stroke(60, 120, 200);
  strokeWeight(2);
  fill(100, 160, 230);
  ellipse(px, py, pr*2, pr*2);
  noStroke();

  // ── HUD ──
  fill(0);
  textAlign(LEFT, TOP);
  textSize(16);
  text("Score: " + score, 15, 15);
  
  // Timer (turns red when low)
  if (timeLeft <= 10) fill(220, 50, 50);
  else fill(0);
  text("Time: " + timeLeft + "s", 15, 38);

  fill(80);
  textSize(13);
  text("Trails: " + (trails ? "ON" : "OFF") + " (T)  |  Speed: +/-", width/2 - 120, 15);
}

void drawEndScreen() {
  textAlign(CENTER, CENTER);

  fill(200, 50, 50);
  textSize(32);
  text("TIME'S UP!", width/2, height/2 - 70);

  fill(30);
  textSize(20);
  text("Final Score: " + score, width/2, height/2 - 20);

  // Message based on score
  String msg = "";
  if (score >= 20)     msg = "Outstanding! You're a pro!";
  else if (score >= 10) msg = "Great job! Keep it up!";
  else if (score >= 5)  msg = "Good effort! Practice more!";
  else                  msg = "Keep trying! You'll get there!";

  fill(80);
  textSize(16);
  text(msg, width/2, height/2 + 20);

  fill(30, 150, 80);
  textSize(20);
  text("Press R to Restart", width/2, height/2 + 70);
}

void keyPressed() {
  // Start game
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis();
    score = 0;
    orbCatches = 0;
    trails = false;
    goldActive = false;
    oxs = 4; oys = 3;   // reset orb speeds
    ox2s = -3.5; oy2s = 2.5;
    resetPositions();
  }

  // Restart
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0;
  }

  // Trail toggle (during play)
  if (key == 't' || key == 'T') trails = !trails;

  // Speed control
  if (key == '+' || key == '=') { oxs *= 1.2; oys *= 1.2; ox2s *= 1.2; oy2s *= 1.2; }
  if (key == '-')                { oxs *= 0.8; oys *= 0.8; ox2s *= 0.8; oy2s *= 0.8; }
}
