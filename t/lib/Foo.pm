package Foo;

use Mongoose;

our $database =
    Mongoose->db( class => 'Foo', db_name => 'foo' );
    Mongoose->naming('plural');
    Mongoose->load_schema( search_path => 'Foo', shorten => 1 );

sub database { $database }
sub users { User }

1;
