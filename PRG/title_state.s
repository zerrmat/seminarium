.include "title_consts.h"
.import titleScrollY

.export init_title_state

init_title_state:
	lda #TITLE_START_SCROLL_POS
	sta titleScrollY