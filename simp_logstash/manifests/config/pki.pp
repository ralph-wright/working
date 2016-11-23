## Class: simp_logstash::config::config::pki
#
# This class is meant to be called from simp_logstash.
# It ensures that pki rules are defined.
#
# @private
#
class simp_logstash::config::pki {
  assert_private()

  include '::pki'

  ::pki::copy {'/etc/logstash': group => 'logstash'}
}

