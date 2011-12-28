use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'constant::our',
    license           => 'perl',
    dist_author       => 'Green <Evdokimov.Denis@gmail.com>',
    dist_version_from => 'lib/constant/our.pm',
    build_requires    => {
                        'Test::More' => 0,
                        'constant'   => 0,
                        'Exporter'   => 0,
    },
    add_to_cleanup     => ['constant::our-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
