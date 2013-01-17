use inc::Module::Install;
name 'CommentEater';
all_from 'lib/CommentEater.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
