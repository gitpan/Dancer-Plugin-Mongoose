package Foo::User;

use Mongoose::Class;
    with 'Mongoose::Document';

has qw/name is rw isa Str/;

1;
