## no critic: InputOutput::RequireBriefOpen

package App::wcgrep;

use 5.010001;
use strict;
use warnings;
use Log::ger;

use AppBase::Grep;
use AppBase::Grep::File ();
use Perinci::Sub::Util qw(gen_modified_sub);

# AUTHORITY
# DATE
# DIST
# VERSION

our %SPEC;

gen_modified_sub(
    output_name => 'wcgrep',
    base_name   => 'AppBase::Grep::grep',
    summary     => 'Print lines matching a wildcard pattern',
    description => <<'_',

This is another grep-like utility that is based on <pm:AppBase::Grep>, mainly
for demoing and testing the module. It accepts bash wildcard pattern instead of
regular expression.

_
    add_args    => {
        %AppBase::Grep::File::argspecs_files,
    },
    modify_meta => sub {
        my $meta = shift;

        # modify arg
        $meta->{args}{pattern} = {
            summary => 'Specify *wildcard pattern* to search for',
            schema => 'str*',
            req => 1,
            pos => 0,
        };

        # delete args
        delete $meta->{args}{regexps};
        delete $meta->{args}{dash_prefix_inverts};
        delete $meta->{args}{all};

        $meta->{examples} = [
            {
                summary => 'Show lines that contain foo and bar, in that order',
                'src' => q([[prog]] 'foo.*bar' file1 file2),
                'src_plang' => 'bash',
                'test' => 0,
                'x.doc.show_result' => 0,
            },
        ];
        $meta->{links} = [
            {url=>'prog:abgrep'},
        ];
    },
    output_code => sub {
        my %args = @_;

        # convert wildcard pattern to regex
        my $pat = delete $args{pattern};
        require String::Wildcard::Bash;
        my $re = String::Wildcard::Bash::convert_wildcard_to_re($pat);
        $args{regexps} = [$re];

        AppBase::Grep::File::set_source_arg(\%args);
        AppBase::Grep::grep(%args);
    },
);

1;
# ABSTRACT:
