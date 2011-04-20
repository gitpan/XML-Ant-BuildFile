#!perl
#
# This file is part of XML-Ant-BuildFile
#
# This software is copyright (c) 2011 by GSI Commerce.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.010;
use utf8;
use Modern::Perl;    ## no critic (UselessNoCritic,RequireExplicitPackage)

use English '-no_match_vars';
use Test::Most;
use Readonly;
use XML::Ant::BuildFile::Project;

my $tests;
Readonly my $PROJECT =>
    XML::Ant::BuildFile::Project->new( file => 't/yui-build.xml' );

my @java_tasks = $PROJECT->target('compress-files')->tasks('java');

for my $task (@java_tasks) {
    is( $task->jar, '${yuicompressor.jar}', 'unexpanded jar property' );
    $tests++;

    my @args = $task->args;
    cmp_deeply(
        [ @args[ 0, 2, 3, 5 ] ],
        [qw(--type --charset utf-8 -o)],
        'static args',
    );
    $tests++;
}

cmp_deeply(
    [ map { @{ [ $ARG->args ] }[ 4, 6 ] } @java_tasks ],
    [   't/target/yui/concat/site.css',
        't/target/yui/mincat/css/min/site.css',
        't/target/yui/concat/site.js',
        't/target/yui/mincat/js/min/site.js',
    ],
    'pathref args',
);
$tests++;

done_testing($tests);