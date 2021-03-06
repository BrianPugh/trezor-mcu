#include <stdio.h>
#include <stdlib.h>
#include <readline/readline.h>
#include <readline/history.h>

#include "fonts.h"

static inline char convert(char c) {
	if (c < 0x80) {
		return c;
	} else if (c >= 0xC0) {
		return '_';
	} else {
		return '\0';
	}
}

int main(int argc, char **argv) {
	char *line;
	while ((line = readline(NULL)) != NULL) {
		size_t length = strlen(line);
		if (length) {
			add_history(line);
		}

		size_t width = 0;
		for (size_t i = 0; i < length; i++) {
			width += fontCharWidth(convert(line[i])) + 1;
		}

		printf("%zu\n", width);
		free(line);
	}
}
