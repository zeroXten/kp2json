kp2json
=======

Reads a KeePass database file and outputs entries as json

Requirements
============

Uses File::KeePass available here http://search.cpan.org/~rhandom/File-KeePass-2.03/ or via CPAN

Usage
=====

    Usage: kp2json.pl FILE SEARCH [SEARCH]

    Examples

    This will search for the title 'linux root user':
      kp2json.pl password.kdb 'linux root user'

    This will search for the username 'root':
      kp2json.pl password.kdb username:root

    A single result will output directly as a hash. Multiple results will be output in an array under the 'entries' key.

Example
=======

Single entry

    $ ./kp2json.pl ~/testing.kdb Testing
    Password:
    {"modified":"2014-02-04 16:42:00","username":"root","created":"2014-02-04 16:41:46","comment":"","url":"","title":"Testing","accessed":"2014-02-04 16:42:00","expires":"2999-12-28 23:59:59"}

Multiple entries

    $ kp2json.pl ~/testing.kdb username:root
    Password:
    {"entries":[{"modified":"2014-02-04 16:42:00","username":"root","created":"2014-02-04 16:41:46","comment":"","url":"","title":"Testing","accessed":"2014-02-04 16:42:00","expires":"2999-12-28 23:59:59"},{"modified":"2014-02-06 14:52:33","username":"root","created":"2014-02-06 14:52:20","comment":"","url":"","title":"Bagers","accessed":"2014-02-06 14:52:33","expires":"2999-12-28 23:59:59"}]}

Using it with chef-vault

    $ kp2json.pl ~/testing.kdb Testing | knife vault create secrets testing -J /dev/stdin --admins admin-user
