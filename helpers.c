/*********************************************************************
 *
 * Copyright (C) 2003,  Blekinge Institute of Technology
 *
 * Filename:      helpers.c
 * Author:        Simon Kagstrom <ska@bth.se>
 * Description:   Library with helpers for the nibbles game
 *
 * $Id: helpers.c 4937 2005-10-06 12:50:50Z ska $
 *
 *
 ********************************************************************
 *
 * Modification of original:
 * Modified by:   Christoffer Åleskog <cck@bth.se>
 * Modified date: 2024-10-14
 *
 ********************************************************************/

#include <ncurses.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

static WINDOW *p_screen;

int board_get_key(void) {
  int key = getch();

  return key;
}

void board_put_char(int x, int y, int ch) {
  mvprintw(y, x, "%c", ch);
  wrefresh(p_screen);
}

void board_put_str(int x, int y, const char *str) {
  mvprintw(y, x, "%s", str);
  wrefresh(p_screen);
}

void board_init(void) {
  srand(time(0));          /* Init randomiser */
  p_screen = initscr();    /* Create the window */
  start_color();           /* We use color (well...) */
  curs_set(0);             /* Make cursor invisible */
  noecho();                /* Don't output chars on screen when written */
  keypad(p_screen, TRUE);  /* Give p_screen keyboard focus */
  nodelay(p_screen, TRUE); /* Make getch nonblocking */
}

void game_exit(void) {
  delwin(p_screen);
  endwin();
  exit(0);
}
