use strict;
use warnings;
use Test::More tests => 1, import => ['!pass'];
use Test::Exception;

BEGIN {
    use FindBin;
    use lib $FindBin::Bin . "/lib";
}

use Dancer ':syntax';
use_ok 'Dancer::Plugin::Mongoose';
