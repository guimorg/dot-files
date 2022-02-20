# -----------------------------------------------
# BEFORE USING THIS SCRIPT
# -----------------------------------------------
# 1 - Create a file in /etc/<yourpassfile>.pass which contains the vpn private key password.
# 2 - Set permission for the file: 'sudo chmod 600 /etc/<yourpassfile>.pass' - Owner can read and write.
# 3 - Create an alias in your .bashrc or bash_profile: alias vpn="sudo sh <path to your script>".
# 4 - Set the value of the variable OVPN_FILE_PATH with the path of the .ovpn file.
# 5 - Set the value of the variable OVPN_PRIVATE_KEY_FILE_PATH with the path of the created file in step #1: /etc/<yourpassfile>.pass
# 6 - OPTIONAL: avoid  password when executing the script, add this to /etc/sudoers '<your username> ALL=(ALL:ALL) NOPASSWD:<path to your script>'


# -----------------------------------------------
# TIPS
# -----------------------------------------------
# 1 - Add the script to sudoers so you do not have to enter your password every time the script is executed.


# -----------------------------------------------
# POTENTIAL ISSUES WITH openvpn AND LINUX
# -----------------------------------------------
# 1 - When a Linux/Unix client is used with Access Server, the Access Server is unable to alter the DNS settings on the client in question.
# 2 - https://openvpn.net/index.php/access-server/docs/admin-guides/182-how-to-connect-to-access-server-with-linux-clients.html
# Resolve it:
#	https://wiki.archlinux.org/index.php/OpenVPN#DNS
#	https://github.com/jonathanio/update-systemd-resolved
#	https://serverfault.com/questions/590706/openvpn-client-force-dns-server
#	https://bugs.launchpad.net/ubuntu/+source/systemd/+bug/1685900


# -----------------------------------------------
# USAGE
# -----------------------------------------------
# This script needs to be run as 'sudo' as setup in step #3.
# Allowed parameters: 
# start: starts the VPN connection. Example 'vpn start'
#	stop: stops the VPN connection. Example 'vpn stop'
#	restart: restarts the VPN connection. Example 'vpn restart'
#	status: show whether the VPN process is running. Example 'vpn status'
#	help: prints help on screen. Example 'vpn help'


# -----------------------------------------------
# VARIBLES
# -----------------------------------------------
OVPN_FILE_PATH='/home/guimorg/.secrets/ifood.ovpn'

PARAM_START='start'
PARAM_STOP='stop'
PARAM_RESTART='restart'
PARAM_STATUS='status'
PARAM_HELP='help'

HELP_MSG="PARAMETERS: start, stop, restart, status, help. Example: 'vpn start'"
ERROR_MSG="Run 'vpn help' for a list of allowed parameters."


# -----------------------------------------------
# FUNCTIONS
# -----------------------------------------------
start_vpn()
{	
  echo 'Connecting to VPN...'
  sudo openvpn --config $OVPN_FILE_PATH --daemon --writepid /run/openvpn/ifood.pid
  echo 'Connected!'
  export DISPLAY=:0.0
  notify-send "Connected to VPN!"
}

stop_vpn()
{
  echo 'Stopping VPN Connection...'
  sudo killall openvpn
  echo 'Removing VPN tunnel if exists...'
  sudo ip link delete tun0  
  echo 'Disconnected!'
  DISPLAY=:0.0 notify-send "Disconnected from VPN!"
}

restart_vpn()
{
  stop_vpn
  start_vpn
}

status_vpn()
{
  ps -a | grep openvpn
  echo 'VPN running in this process.'
}

# -----------------------------------------------
# MAIN BODY
# -----------------------------------------------
case $1 in
  '') start_vpn ;;
  $PARAM_START) start_vpn ;;
  $PARAM_STOP) stop_vpn ;;
  $PARAM_RESTART) restart_vpn ;;
  $PARAM_STATUS) status_vpn ;;
  $PARAM_HELP) echo $HELP_MSG ;;
  *) echo $ERROR_MSG
esac
