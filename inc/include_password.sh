#!/usr/bin/env bash

################################################################################
# Password
################################################################################

# Generate a valid SAP master password
#
# The valid characters are: A-Z, a-z, 0-9, $, #, _
# The first character has to be one of the following: A-Z, a-z, $, #
# The first 3 characters cannot be one and the same
# The password must contain at least 1 lowercase letter(s)
# The password must contain at least 1 uppercase letter(s)
# The password must contain at least 1 digit(s)
# The password must be between 10 and 14 characters long
#
# Out: MY_PASSWORD
function generate_password() {
	MY_CHARS='$#_'
	MY_PASSWORD=$({
		</dev/urandom LC_ALL=C grep -ao '[A-Z]' | head -n1
		</dev/urandom LC_ALL=C grep -ao '[a-z]' | head -n1
		</dev/urandom LC_ALL=C grep -ao '[0-9]' | head -n1
		echo ${MY_CHARS:$((RANDOM % ${#MY_CHARS})):1}
		</dev/urandom LC_ALL=C grep -ao '[A-Za-z0-9]' | head -n10
	} | tr -d '\n')
	export MY_PASSWORD
}
