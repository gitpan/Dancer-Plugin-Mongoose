# ABSTRACT: Mongoose interface for Dancer applications

package Dancer::Plugin::Mongoose;
BEGIN {
  $Dancer::Plugin::Mongoose::VERSION = '0.00001';
}

use strict;
use warnings;
use Dancer::Plugin;
use Mongoose;


my $schemas = {};

register schema => sub {
    my $name = shift;
    my $cfg = plugin_setting;

    if (not defined $name) {
        ($name) = keys %$cfg or die "No schemas are configured";
    }

    return $schemas->{$name} if $schemas->{$name};

    my $options = $cfg->{$name} or die "The schema $name is not configured";

    my $class = $options->{class};

    if ($class) {
        
        $class =~ s/-/::/g;
        
        eval "use $class";
        
        if ( my $err = $@ ) {
            die "error while loading $class : $err";
        }
        
        $schemas->{$name} = $class
    }

    # explicitly set host
    my $host = $options->{host};
    Mongoose->_args->{host} = $host if $host;

    return $schemas->{$name};
};

register_plugin;

1;

__END__
=pod

=head1 NAME

Dancer::Plugin::Mongoose - Mongoose interface for Dancer applications

=head1 VERSION

version 0.00001

=head1 SYNOPSIS

    # Dancer Code File
    use Dancer;
    use Dancer::Plugin::Mongoose;

    get '/profile/:id' => sub {
        my $user = schema->users->find_one(params->{id});
        
        # or explicitly ask for a schema by name:
        $user = schema('foo')->users->find_one(params->{id});
        template user_profile => { user => $user };
    };

    dance;

    # Dancer Configuration File (minimumal settings)
    plugins:
      DBIC:
        foo:
          class:  "Foo::Bar"

Database connection details are read from your Dancer application config - see
below.

=head1 DESCRIPTION

This plugin provides an easy way to obtain L<Mongoose> derived class instances
via the the function schema(), which it automatically imports. You just need to
point to a class in your L<Dancer> configuration file.

=head1 CONFIGURATION

Connection details will be grabbed from your L<Dancer> config file.
For example: 

    plugins:
      Mongoose:
        foo:
          class: Foo
          "mongodb://localhost:27017"
        bar:
          class: Foo::Bar
        baz:
          class: Foo::Baz
          host: "mongodb://elsewhere:27017"

Each schema configuration *must* have a class option. If the host option is
omitted it is assumed that it is hard-coded in the class or that localhost
should be used. The host option should be the L<MongoDB> driver connection
string.

The class option provided should be a proper Perl package name that
Dancer::Plugin::Mongoose will use as a Mongoose derived class.

=head1 AUTHOR

Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

