#!/bin/bash

function start_vpn() {
    sudo openfortivpn vpn.ifoodcorp.com.br --svpn-cookie $1
}

# making qt webengine less verbose
export QT_LOGGING_RULES="*=false;webview=true"
export QTWEBENGINE_CHROMIUM_FLAGS="--enable-logging --log-level=3"

while true; do
    cookie=$(openfortivpn-webview vpn.ifoodcorp.com.br 2>/dev/null)
    if [ $? -ne 0 ]; then
        # Exit if the user the browser window has been closed manually.
        exit 0
    fi
    start_vpn $cookie
done
