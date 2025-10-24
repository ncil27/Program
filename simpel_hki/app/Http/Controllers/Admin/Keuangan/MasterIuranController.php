<?php

namespace App\Http\Controllers\Admin\Keuangan;

use App\Http\Controllers\Controller;
use App\Models\MasterIuran;
use Illuminate\Http\Request;

class MasterIuranController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $masterIurans = MasterIuran::orderBy('tahun', 'desc')->get();
        return view('admin.master-iuran.index', compact('masterIurans'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'tahun' => 'required|integer|unique:master_iuran,tahun',
            'jumlah_patokan_tahunan' => 'required|numeric',
            'keterangan' => 'nullable|string',
        ]);

        MasterIuran::create([
            'tahun' => $request->tahun,
            'jumlah_patokan_tahunan' => $request->jumlah_patokan_tahunan,
            'keterangan' => $request->keterangan,
        ]);

        return redirect()->route('master-iuran.index')->with('success', 'Nominal Persembahan Bulanan baru berhasil ditambahkan .');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, MasterIuran $masterIuran)
    {
        $request->validate([
            'jumlah_patokan_tahunan' => 'required|numeric',
            'keterangan' => 'nullable|string',
        ]);

        $masterIuran->update([
            'jumlah_patokan_tahunan' => $request->jumlah_patokan_tahunan,
            'keterangan' => $request->keterangan,
        ]);

        return redirect()->route('master-iuran.index')->with('success', 'Nominal Persembahan Bulanan berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
