SERVER_HELLO_MESSAGE="VPN admin interface." # Hello message on login

NOTIFY_ON_CHANGE_EMAIL="test@test.com" # Email which will be notified on new and revoke actions. Notifications disabled if empty

SEND_USER_CONF_IN_NOTIFICATION="yes" # Attach user config to this notification

NEW_KEY_MAIL_THEME="VPN Access Granted" # Theme of new key notification email

REVOKE_KEY_MAIL_THEME="VPN Access Revoked" # Theme of revoke notification email

NEW_KEY_MAIL_TEMPLATE="new_key.tsh" # Template for body of new key email (bash script with echo)

REVOKE_KEY_MAIL_TEMPLATE="revoke_key.tsh" # Template for body of revoke email (bash script with echo)

OPENVPN_VARS="/etc/openvpn/vars" # Path to edited easy-rsa vars

OPENVPN_CONF_TEMPLATE="Template.ovpn" # Path to preconfigured .ovpn (without keys)

OPENVPN_USER="openvpn" # OpenVPN server user. Can be root or nobody or custom user

OPENVPN_KEY_BACKUP_DIR="/etc/openvpn/key_backup" # Directory with less rights for key backup (accessible only with notify then).
