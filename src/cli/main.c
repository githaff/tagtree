#include <stdio.h>
#include <extopts/extopts.h>

#include "trut/trut.h"

#include "config.h"


struct extopt trut_opts[];

void trut_usage(void)
{
	printf("Usage: trut COMMAND [COMMAND_OPTIONS]\n"
		   "Trut tagging utility.\n");
	printf("\n");
	printf("Options:\n");
	extopts_usage(trut_opts);
}

void trut_version(void)
{
	printf("Trut tagging utility %s\n", TRUT_VERSION_FULL);
}

bool opts_help;
bool opts_version;

struct extopt trut_opts[] = {
	EXTOPTS_HELP(&opts_help),
	EXTOPTS_VERSION(&opts_version),
	EXTOPTS_END
};

int main(int argc, char *argv[])
{
	int ret;

	ret = extopts_get(&argc, argv, trut_opts);
	if (ret)
		goto err;

	if (opts_help) {
		trut_usage();
		goto end;
	}
	if (opts_version) {
		trut_version();
		goto end;
	}

    printf("Print from trut client\n");
    func();
	
err:
end:
    return ret;
}
