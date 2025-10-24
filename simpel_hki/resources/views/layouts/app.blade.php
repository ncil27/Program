<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'Laravel') }}</title>

        <!-- Fonts -->
        <link rel="preconnect" href="{{asset('https://fonts.bunny.net')}}">
        <link href="{{asset('https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap')}}" rel="stylesheet" />
        <link href="{{asset('https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap')}}" rel="stylesheet">
        <link rel="stylesheet" href="{{asset('template/css/bootstrap.css')}}">
        <link rel="stylesheet" href="{{asset('template/vendors/iconly/bold.css')}}">
        <link rel="stylesheet" href="{{asset('template/vendors/perfect-scrollbar/perfect-scrollbar.css')}}">
        <link rel="stylesheet" href="{{asset('template/vendors/bootstrap-icons/bootstrap-icons.css')}}">
        <link rel="stylesheet" href="{{asset('template/css/app.css')}}">

        <!-- Scripts -->
        @vite(['resources/css/app.css', 'resources/js/app.js'])

        
    </head>
    <body class="font-sans antialiased">
        <div id="app">
        <div id="sidebar" class="active">
            <div class="sidebar-wrapper active">
                <div class="sidebar-header">
                    <div class="d-flex justify-content-between">
                        <div class="logo">
                            <a href="index.html"><img src="template/images/logo/logo.png" alt="Logo" srcset=""></a>
                        </div>
                        <div class="toggler">
                            <a href="#" class="sidebar-hide d-xl-none d-block"><i class="bi bi-x bi-middle"></i></a>
                        </div>
                    </div>
                </div>
                <div class="sidebar-menu">
                    <ul class="menu">
                        <li class="sidebar-item {{ request()->is('dashboard') ? 'active' : '' }}">
                            <a href="{{ route('dashboard') }}" class='sidebar-link'>
                                <i class="bi bi-grid-fill"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>

                        <li class="sidebar-item  has-sub">
                            <a href="#" class='sidebar-link'>
                                <i class="bi bi-stack"></i>
                                <span>Data Master</span>
                            </a>
                            <ul class="submenu ">
                                <li class="submenu-item ">
                                    <a href="component-alert.html">Keluarga</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="component-badge.html">Jemaat</a>
                                </li>
                                <li class="submenu-item {{ request()->is('sektor*') ? 'active' : '' }}">
                                    <a href="{{route('sektor.index')}}">Sektor</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="component-button.html">User</a>
                                </li>

                            </ul>
                        </li>

                        <li class="sidebar-item  has-sub">
                            <a href="#" class='sidebar-link'>
                                <i class="bi bi-collection-fill"></i>
                                <span>Data Jemaat</span>
                            </a>
                            <ul class="submenu ">
                                <li class="submenu-item ">
                                    <a href="extra-component-avatar.html">Baptis || Sidi</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="extra-component-sweetalert.html">Martumpol || Pernikahan</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="extra-component-toastify.html">Jemaat Pindah</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="extra-component-rating.html">Meninggal</a>
                                </li>
                            </ul>
                        </li>

                        <li class="sidebar-item  has-sub">
                            <a href="#" class='sidebar-link'>
                                <i class="bi bi-cash"></i>
                                <span>Keuangan</span>
                            </a>
                            <ul class="submenu ">
                                <li class="submenu-item ">
                                    <a href="layout-default.html">Transaksi</a>
                                </li>
                                <li class="submenu-item ">
                                    <a href="layout-vertical-1-column.html">Persembahan Bulanan</a>
                                </li>
                                <li class="submenu-item {{ request()->is('master-iuran*') ? 'active' : '' }}">
                                    <a href="{{ route('master-iuran.index') }}">Master Iuran</a>
                                </li>
                            </ul>
                        </li>
                        <li class="sidebar-item">
                            <form method="POST" action="{{ route('logout') }}">
                                @csrf
                                <a href="{{ route('logout') }}" class='sidebar-link' 
                                onclick="event.preventDefault(); 
                                            this.closest('form').submit();">
                                    <i class="bi bi-box-arrow-right"></i> <span>Log Out</span>
                                </a>
                            </form>
                        </li>


                    </ul>
                </div>
                <button class="sidebar-toggler btn x"><i data-feather="x"></i></button>
            </div>
        </div>
        <div id="main">
            <header class="mb-3">
                <a href="#" class="burger-btn d-block d-xl-none">
                    <i class="bi bi-justify fs-3"></i>
                </a>
            </header>

            @if (isset($header))
                <div class="page-heading">
                    <h3>{{ $header }}</h3>
                </div>
            @endif

            <div class="page-content">
                @yield('content')
            </div>

            <!-- <footer>
                <div class="footer clearfix mb-0 text-muted">
                    <div class="float-start">
                        <p>2021 &copy; Mazer</p>
                    </div>
                    <div class="float-end">
                        <p>Crafted with <span class="text-danger"><i class="bi bi-heart"></i></span> by <a
                                href="http://ahmadsaugi.com">A. Saugi</a></p>
                    </div>
                </div>
            </footer> -->
        </div>
    </div>
    <script src="{{asset('template/vendors/perfect-scrollbar/perfect-scrollbar.min.js')}}"></script>
    <script src="{{asset('template/js/bootstrap.bundle.min.js')}}"></script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="{{asset('template/js/main-fixed.js')}}"></script>

    @if (session('success'))
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Berhasil!',
            text: '{!! session('success') !!}',
            timer: 1000,
            showConfirmButton: false
        });
    </script>
    @endif

    @stack('scripts')

    </body>
</html>
