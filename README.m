import pygame
import random

# Initialize Pygame
pygame.init()

# Constants
WIDTH, HEIGHT = 800, 600
PLAYER_SPEED = 5
ENEMY_SPEED = 2
BULLET_SPEED = 10

# Colors
WHITE = (255, 255, 255)
RED = (255, 0, 0)

# Create the screen
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Super Hero Game")

# Player
player_img = pygame.image.load('player.png')
player_x = WIDTH // 2
player_y = HEIGHT - 64
player_x_change = 0

# Enemies
enemy_img = pygame.image.load('enemy.png')
enemy_x = random.randint(0, WIDTH)
enemy_y = random.randint(50, 150)
enemy_x_change = ENEMY_SPEED
enemy_y_change = 40

# Bullets
bullet_img = pygame.image.load('bullet.png')
bullet_x = 0
bullet_y = HEIGHT - 64
bullet_x_change = 0
bullet_y_change = BULLET_SPEED
bullet_state = "ready"

# Game Loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # Player controls
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                player_x_change = -PLAYER_SPEED
            if event.key == pygame.K_RIGHT:
                player_x_change = PLAYER_SPEED
            if event.key == pygame.K_SPACE:
                if bullet_state == "ready":
                    bullet_x = player_x
                    fire_bullet(bullet_x, bullet_y)

        if event.type == pygame.KEYUP:
            if event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                player_x_change = 0

    # Update player position
    player_x += player_x_change

    # Enemy movement
    enemy_x += enemy_x_change
    if enemy_x <= 0 or enemy_x >= WIDTH - 64:
        enemy_x_change = -enemy_x_change
        enemy_y += enemy_y_change

    # Bullet movement
    if bullet_state == "fire":
        fire_bullet(bullet_x, bullet_y)
        bullet_y -= bullet_y_change
        if bullet_y <= 0:
            bullet_state = "ready"

    # Collision detection
    if is_collision(enemy_x, enemy_y, bullet_x, bullet_y):
        enemy_x = random.randint(0, WIDTH)
        enemy_y = random.randint(50, 150)
        bullet_state = "ready"

    # Draw everything
    screen.fill(WHITE)
    screen.blit(player_img, (player_x, player_y))
    screen.blit(enemy_img, (enemy_x, enemy_y))
    if bullet_state == "fire":
        screen.blit(bullet_img, (bullet_x, bullet_y))

    pygame.display.update()

# Quit the game
pygame.quit()
