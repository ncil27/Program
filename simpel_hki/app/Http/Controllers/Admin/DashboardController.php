<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Jemaat;
use App\Models\Keluarga;

class DashboardController extends Controller
{
    public function index()
    {
        $jumlahJemaat =Jemaat::where('status_keanggotaan', 'Aktif')->count();
        $jumlahKeluarga =Keluarga::where('status_keluarga', 'Aktif')->count();

        return view('dashboard', [
            'total_jemaat' => $jumlahJemaat,
            'total_keluarga' => $jumlahKeluarga,
        ]);
    }
}
