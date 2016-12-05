#include <stdio.h>
#include <string.h>
#include <openssl/md5.h>

#define PASSWORD_LENGTH 8
#define INPUT "ojvtpuvg"

int main()
{
	uint8_t result[MD5_DIGEST_LENGTH], x = 0, j, c;
	uint64_t i = 0;
	char input[50];

	while (x < PASSWORD_LENGTH) {
		sprintf(input, INPUT "%lu", i++);
		MD5(input, strlen(input), result);
		if (*(uint32_t *)result & 0xf0ffff)
			continue;
		for (j = 0; j < MD5_DIGEST_LENGTH; ++j)
			sprintf(&input[j*2], "%02x", result[j]);
		putchar(input[5]);
		++x;
	}
	putchar('\n');
}
