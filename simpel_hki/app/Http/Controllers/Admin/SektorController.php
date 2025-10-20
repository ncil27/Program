<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Sektor;

class SektorController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $sektors = Sektor::all();

        return view('admin.sektor.index', ['sektors' => $sektors]);
        // return view('admin.sektor.index');
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_sektor' => 'required|string|max:100,unique:sektor,nama_sektor',
            'keterangan' => 'required|string',
        ]);

        Sektor::create([
            'nama_sektor' => $request->nama_sektor,
            'keterangan' => $request->keterangan,
        ]);

        return redirect()->route('sektor.index')->with('success', 'Sektor berhasil ditambahkan.');
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
    public function update(Request $request, Sektor $sektor)
    {
        $request->validate([
            'nama_sektor' => 'required|string|max:100|unique:sektor,nama_sektor,' . $sektor->id_sektor . ',id_sektor',
            'keterangan' => 'required|string',
        ]);

        $sektor->update([
            'nama_sektor' => $request->nama_sektor,
            'keterangan' => $request->keterangan,
        ]);

        return redirect()->route('sektor.index')->with('success', 'Sektor berhasil diperbarui!');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Sektor $sektor)
    {
        // $sektor = Sektor::findOrFail($id);
        $sektor->delete();
        return redirect()->route('sektor.index')->with('success', 'Sektor berhasil dihapus!');
    }
}
