//
//  CDBUUID.m
//  CDBUUID
//
//  This file includes third-party code, see below for copyright statements.
//

#import "CDBUUID.h"

#import <CommonCrypto/CommonCrypto.h>


static NSString *Base64StringFromBytes(char, u_char *, size_t);
static NSInteger url_b64_ntop(u_char const *, size_t, char *, size_t);


@implementation CDBUUID

#pragma mark - class public -

+ (NSString *)UUIDString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuid);
    
    NSString *result = Base64StringFromBytes('u', (UInt8 *)&bytes, sizeof(bytes));
    
    CFRelease(uuid);
    return result;
}

+ (NSString *)sha1UsingUUIDStrings:(NSString *)ident, ... {
    u_char digest[CC_SHA1_DIGEST_LENGTH];
    
    __block CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    {
        va_list args;
        va_start(args, ident);
        for (id arg = ident; arg != nil; arg = va_arg(args, id)){
            NSData *data = [arg dataUsingEncoding:NSUTF8StringEncoding];
            CC_SHA1_Update(&ctx, [data bytes], (unsigned int)[data length]);
        }
        va_end(args);
    }
    CC_SHA1_Final(digest, &ctx);
    
    return Base64StringFromBytes('z', digest, sizeof(digest));
}

@end


#pragma mark - Helpers

static NSString *Base64StringFromBytes(char prefix, u_char *data, size_t len)
{
    // (buffer_size + 1) for the prefix
    size_t buffer_size = (len * 3 + 2) / 2;
    char *buffer = (char *)malloc(buffer_size + 1);
    
    buffer[0] = prefix;
    size_t written = url_b64_ntop(data, len, buffer + 1, buffer_size);
    
    if (written == -1) {
        free(buffer);
        return nil;
    } else {
        NSString * result = [[NSString alloc] initWithBytesNoCopy:buffer
                                                           length:(ceil(len * 8.0 / 6.0) + 1)
                                                         encoding:NSUTF8StringEncoding
                                                     freeWhenDone:YES];
        return result;
    }
}


#pragma mark - third party -

/*	$OpenBSD: base64.c,v 1.5 2006/10/21 09:55:03 otto Exp $	*/

/*
 * Copyright (c) 1996 by Internet Software Consortium.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND INTERNET SOFTWARE CONSORTIUM DISCLAIMS
 * ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL INTERNET SOFTWARE
 * CONSORTIUM BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
 * PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
 * ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 */

/*
 * Portions Copyright (c) 1995 by International Business Machines, Inc.
 *
 * International Business Machines, Inc. (hereinafter called IBM) grants
 * permission under its copyrights to use, copy, modify, and distribute this
 * Software with or without fee, provided that the above copyright notice and
 * all paragraphs of this notice appear in all copies, and that the name of IBM
 * not be used in connection with the marketing of any product incorporating
 * the Software or modifications thereof, without specific, written prior
 * permission.
 *
 * To the extent it has a right to do so, IBM grants an immunity from suit
 * under its patents, if any, for the use, sale or manufacture of products to
 * the extent that such products are used for performing Domain Name System
 * dynamic updates in TCP/IP networks by means of the Software.  No immunity is
 * granted for any product per se or for any other function of any product.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", AND IBM DISCLAIMS ALL WARRANTIES,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE.  IN NO EVENT SHALL IBM BE LIABLE FOR ANY SPECIAL,
 * DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING
 * OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE, EVEN
 * IF IBM IS APPRISED OF THE POSSIBILITY OF SUCH DAMAGES.
 */

/*
 * Modified 2014 by Ben Weaver <ben@orangesoda.net> to use "url safe" encoding.
 */

/* OPENBSD ORIGINAL: lib/libc/net/base64.c */

static const char StandardPad64 = '=';
static const char URLSafeBase64[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

static NSInteger url_b64_ntop(u_char const *src, size_t srclength, char *target, size_t targsize)
{
    const char *alphabet = URLSafeBase64;
	size_t datalength = 0;
	u_char input[3];
	u_char output[4];
	u_int i;
    
	while (2 < srclength) {
		input[0] = *src++;
		input[1] = *src++;
		input[2] = *src++;
		srclength -= 3;
        
		output[0] = input[0] >> 2;
		output[1] = ((input[0] & 0x03) << 4) + (input[1] >> 4);
		output[2] = ((input[1] & 0x0f) << 2) + (input[2] >> 6);
		output[3] = input[2] & 0x3f;
        
		if (datalength + 4 > targsize)
			return (-1);
		target[datalength++] = alphabet[output[0]];
		target[datalength++] = alphabet[output[1]];
		target[datalength++] = alphabet[output[2]];
		target[datalength++] = alphabet[output[3]];
	}
    
	/* Now we worry about padding. */
	if (0 != srclength) {
		/* Get what's left. */
		input[0] = input[1] = input[2] = '\0';
		for (i = 0; i < srclength; i++)
			input[i] = *src++;
        
		output[0] = input[0] >> 2;
		output[1] = ((input[0] & 0x03) << 4) + (input[1] >> 4);
		output[2] = ((input[1] & 0x0f) << 2) + (input[2] >> 6);
        
		if (datalength + 4 > targsize)
			return (-1);
		target[datalength++] = alphabet[output[0]];
		target[datalength++] = alphabet[output[1]];
		if (srclength == 1)
			target[datalength++] = StandardPad64;
		else
			target[datalength++] = alphabet[output[2]];
		target[datalength++] = StandardPad64;
	}
	if (datalength >= targsize)
		return (-1);
	target[datalength] = '\0';	/* Returned value doesn't count \0. */
	return (datalength);
}