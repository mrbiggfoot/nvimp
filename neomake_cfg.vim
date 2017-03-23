" Neomake execution configuration.
autocmd BufWritePost,BufReadPost *.cc,*.h Neomake

" Project-specific neomake configuration.
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
\ 'exe' : '/opt/clang-3.8/usr/bin/clang++',
\ 'args' : [
\ '-fsyntax-only',
\ '-fvisibility-inlines-hidden',
\ '-xc++',
\ '-Wall',
\ '-Wextra',
\ '-Werror',
\ '-Wno-enum-compare',
\ '-Wno-ignored-qualifiers',
\ '-Wno-unused-parameter',
\ '-march=nehalem',
\ '-mtune=haswell',
\ '-D_GNU_SOURCE',
\ '-D__STDC_FORMAT_MACROS',
\ '-DARENA_LSAN_LEVEL=1',
\ '-Wno-invalid-offsetof',
\ '-std=c++14',
\ '-gcc-toolchain',
\ '/opt/rh/devtoolset-3/root/usr',
\ '-B',
\ '/opt/rh/devtoolset-3/root/usr/bin',
\ '-Qunused-arguments',
\ '-Wno-deprecated-register',
\ '-Wno-unused-local-typedef',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2/x86_64-redhat-linux',
\ '-isystem',
\ '/opt/rh/devtoolset-3/root/usr/include/c++/4.9.2/backward',
\ '-isystem',
\ '/home/apyatkov/projects/main/build',
\ '-isystem',
\ '/home/apyatkov/projects/main/build/toolchain/include',
\ '-I',
\ '/home/apyatkov/projects/main'
\ ]
\ }
