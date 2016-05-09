Default Kickstart Files
=======================

Default Puppet Master Kickstart file (contains default RPMs)

::


    #
    # Use the following Ruby code to generate your password hashes:
    #   ruby -r 'digest/sha2' -e 'puts "password".crypt("$6$" + rand(36**8).to_s(36))'
    #
    # Use the following command to generate your grub password hash:
    #   grub2-mkpasswd-pbkdf2
    #
    # Replace the following strings in this file
    # #BOOTPASS# - Your hashed bootloader password
    # #ROOTPASS# - Your hashed root password
    # #KSSERVER# - The IP address of your Kickstart server
    # #YUMSERVER# - The IP address of your YUM server
    # #LINUXDIST# - The LINUX Distribution you are kickstarting
    #        - Current CASE SENSITIVE options: RedHat CentOS

    authconfig --enableshadow --passalgo=sha512
    bootloader --location=mbr --append="console=ttyS1,57600 console=tty1" --iscrypted --password=#BOOTPASS#
    rootpw --iscrypted #ROOTPASS#
    zerombr
    firewall --enabled --ssh
    firstboot --disable
    logging --level=info
    network --bootproto=dhcp
    reboot
    selinux --permissive
    timezone --utc GMT

    install
    skipx

    %include /tmp/repo-include

    text
    keyboard us
    lang en_US
    url --url http://#YUMSERVER#/yum/#LINUXDIST#/7/x86_64

    %include /tmp/part-include

    %packages --nobase
    -sendmail
    -sysklogd
    acl
    aide
    anacron
    audit
    bzip2
    coolkey
    crontabs
    cryptsetup-luks
    dhclient
    git
    gnupg
    iptables
    iptables-ipv6
    irqbalance
    krb5-workstation
    libaio
    libutempter
    logrotate
    logwatch
    lsof
    lsscsi
    mdadm
    microcode_ctl
    mutt
    net-snmp
    net-tools
    netlabel_tools
    ntp
    openssh-clients
    openssh-server
    pam_krb5
    pam_pkcs11
    pciutils
    psacct
    quota
    redhat-lsb
    rpm
    rsync
    rsyslog
    smartmontools
    sssd
    stunnel
    subversion
    sudo
    sysstat
    tcp_wrappers
    tmpwatch
    unzip
    usbutils
    vim-enhanced
    vlock
    wget
    which
    zip
    # Puppet stuff
    rsync
    facter
    puppet

    # In case of broken repo, these should be installed.
    hdparm
    kbd
    libhugetlbfs
    policycoreutils
    prelink
    rootfiles
    selinux-policy-targeted
    setserial
    sysfsutils
    udftools

    # Don't install these
    -rhn-check
    -rhn-setup
    -rhnsd
    -subscription-manager
    -yum-rhn-plugin
    %end

    %pre
    ksserver="#KSSERVER#"
    wget -O /tmp/diskdetect.sh http://$ksserver/ks/diskdetect.sh;
    chmod 750 /tmp/diskdetect.sh;
    /tmp/diskdetect.sh;
    wget -O /tmp/repodetect.sh http://$ksserver/ks/repodetect.sh;
    chmod 750 /tmp/repodetect.sh;
    /tmp/repodetect.sh '7' $ksserver;
    %end

    %post
    ostype="#LINUXDIST#"
    if [ $ostype == "CentOS" ]; then
        sed -i '/enabled=/d' /etc/yum.repos.d/CentOS-Base.repo;
          sed -i '/\[.*\]/ a\
          enabled=0' /etc/yum.repos.d/CentOS-Base.repo;
          fi
          ksserver="#KSSERVER#"

    # Notify users that bootstrap will run on firstboot
    echo "Welcome to SIMP!  If this is firstboot, SIMP bootstrap is scheduled to run.
    If this host is not autosigned by Puppet, sign your Puppet certs to begin bootstrap.
    Otherwise, it should already be running! Tail /root/puppet.bootstrap.log for details.
    Wait for completion and reboot.

    To remove this message, delete /root/.bootstrap_msg" > /root/.bootstrap_msg
    sed -i "2i if [ -f /root/.bootstrap_msg ]\nthen\n  cat /root/.bootstrap_msg\nfi" /root/.bashrc
    source /root/.bashrc

    # Enable the firstboot bootstrapping script.
    wget --no-check-certificate -O /etc/init.d/runpuppet http://$ksserver/ks/runpuppet;
    chmod 700 /etc/rc.d/init.d/runpuppet;
    chkconfig --add runpuppet;
    chkconfig --level 35 runpuppet on;
    %end
