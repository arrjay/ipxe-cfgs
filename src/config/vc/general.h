#define  NET_PROTO_IPV6          /* IPv6 protocol */
#undef   NET_PROTO_LACP          /* Link Aggregation control protocol */

#define  DOWNLOAD_PROTO_HTTPS    /* Secure Hypertext Transfer Protocol */

#undef   CRYPTO_80211_WEP        /* WEP encryption (deprecated and insecure!) */
#undef   CRYPTO_80211_WPA        /* WPA Personal, authenticating with passphrase */
#undef   CRYPTO_80211_WPA2       /* Add support for stronger WPA cryptography */

#define  NSLOOKUP_CMD            /* DNS resolving command */
#define  TIME_CMD                /* Time commands */
#define  REBOOT_CMD              /* Reboot command */
#define  POWEROFF_CMD            /* Power off command */
#define  PCI_CMD                 /* PCI commands */
#define  PING_CMD                /* Ping command */
#define  CONSOLE_CMD             /* Console command */
#define  NTP_CMD                 /* NTP commands */

#undef BANNER_TIMEOUT            /* Extend Banner timeout */
#define BANNER_TIMEOUT 30

#define EFI_DOWNGRADE_UX         /* retain EFI_LOAD_FILE_PROTOCOL from Firmware */

#undef TIVOLI_VMM_WORKAROUND     /* allow use in KVM without unrestricted guest privs */

