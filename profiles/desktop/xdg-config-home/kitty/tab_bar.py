from kitty.tab_bar import as_rgb, draw_title
from kitty.utils import color_as_int


FIXED_TAB_BODY_WIDTH = 24


def draw_tab(
    draw_data, screen, tab, before, max_tab_length, index, is_last, extra_data
):
    body_width = max(1, min(FIXED_TAB_BODY_WIDTH, max_tab_length))
    end = before + body_width

    trailing_spaces = min(draw_data.trailing_spaces, max(0, body_width - 1))
    leading_spaces = min(
        draw_data.leading_spaces,
        max(0, body_width - trailing_spaces - 1),
    )

    if leading_spaces:
        screen.draw(" " * leading_spaces)

    title_budget = max(0, end - trailing_spaces - screen.cursor.x)
    draw_title(draw_data, screen, tab, index, title_budget)

    title_end = end - trailing_spaces
    if screen.cursor.x > title_end:
        screen.cursor.x = max(before, title_end - 1)
        screen.draw("…")

    if screen.cursor.x < end:
        screen.draw(" " * (end - screen.cursor.x))
    elif screen.cursor.x > end:
        screen.cursor.x = end

    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return end
