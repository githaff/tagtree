#include <stdio.h>
#include <extopts/extopts.h>

#include "tone/tone.h"

#include "config.h"


struct extopt tone_opts[];

void tone_usage(void)
{
	printf("Usage: tone COMMAND [COMMAND_OPTIONS]\n"
		   "Tone tagging utility.\n");
	printf("\n");
	printf("Options:\n");
	extopts_usage(tone_opts);
}

void tone_version(void)
{
	printf("Tone tagging utility %s\n", TONE_VERSION_FULL);
}

bool opts_help;
bool opts_version;

struct extopt tone_opts[] = {
	EXTOPTS_HELP(&opts_help),
	EXTOPTS_VERSION(&opts_version),
	EXTOPTS_END
};

int main(int argc, char *argv[])
{
	int ret;

	ret = extopts_get(&argc, argv, tone_opts);
	if (ret)
		goto err;

	if (opts_help) {
		tone_usage();
		goto end;
	}
	if (opts_version) {
		tone_version();
		goto end;
	}

    printf("Print from tone client\n");
    func();
	
err:
end:
    return ret;
}
