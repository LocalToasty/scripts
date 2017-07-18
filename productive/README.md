A script that blocks distracting websites.

Websites to be blocked when productive mode is turned on have to be inserted into /etc/hosts in the following fashion:

`#127.0.0.1 <website> blocked` (note the leading `#`)

Productive mode can then be enabled by invoking
`$ productive on`
and disabled with
`$ productive off`

The command can furthermore be provided with a timer.
The following call will enable productive mode for 25 minutes:
`$ productive on 25m`