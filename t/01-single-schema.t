use strict;
use warnings;
use Test::More import => ['!pass'];
use Test::Exception;

BEGIN {
    use FindBin;
    use lib $FindBin::Bin . "/lib";
}

use Dancer ':syntax';
use Dancer::Plugin::Mongoose;

    unless ($ENV{MONGOOSE_TEST}) {
        plan skip_all =>
            'Set the env variable MONGOOSE_TEST run tests';
    }
    else {
        plan tests => 3;
    }

set plugins => { Mongoose => { foo => { class => "Foo", }, } };

my $foo = schema;
my $new = $foo->users->new( name => 'the one' );

ok $new, 'created the one.';
ok $new->save, 'saved the one.';
ok $foo->users->find_one({ name => 'the one' }), 'found the one.';

$foo->database->drop; # kill kill kill
