@extends('layouts.app')

@section('header')
    <h2 class="font-semibold text-xl text-gray-800 leading-tight">
        {{ __('Master Persembahan Bulanan') }}
    </h2>
@endsection
@section('content')
<div class="py-12">
    <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
        <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
            <div class="p-6 text-gray-900">

                {{-- FORM TAMBAH DATA --}}
                <div class="card mb-4">
                    <div class="card-header">
                        <strong>Tambah Patokan Iuran Baru</strong>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="{{ route('master-iuran.store') }}">
                            @csrf
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="tahun" class="form-label">Tahun</label>
                                    <input type="number" class="form-control @error('tahun') is-invalid @enderror" id="tahun" name="tahun" placeholder="Contoh: 2025" value="{{ old('tahun') }}" required>
                                    @error('tahun')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="jumlah_patokan_tahunan" class="form-label">Jumlah Patokan (Rp)</label>
                                    <input type="number" class="form-control @error('jumlah_patokan_tahunan') is-invalid @enderror" id="jumlah_patokan_tahunan" name="jumlah_patokan_tahunan" placeholder="Contoh: 600000" value="{{ old('jumlah_patokan_tahunan') }}" required>
                                    @error('jumlah_patokan_tahunan')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                <div class="col-md-2 d-flex align-items-end mb-3">
                                    <button type="submit" class="btn btn-primary w-100">Simpan</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                {{-- TABEL DATA --}}
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Tahun</th>
                            <th>Jumlah Patokan Tahunan</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse ($masterIurans as $iuran)
                            <tr>
                                <td>{{ $iuran->tahun }}</td>
                                <td>Rp {{ number_format($iuran->jumlah_patokan_tahunan, 0, ',', '.') }}</td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary btn-edit-iuran" data-bs-toggle="modal" data-bs-target="#editMasterIuranModal" data-id="{{ $iuran->id}}" data-tahun="{{ $iuran->tahun }}" data-jumlah="{{ $iuran->jumlah_patokan_tahunan }}" data-keterangan="{{ $iuran->keterangan }}">
                                        Edit
                                    </button>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="3" class="text-center">Data masih kosong.</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>

                <div class="modal fade text-left" id="editMasterIuranModal" tabindex="-1" role="dialog" aria-labelledby="editMasterIuranModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title" id="editMasterIuranModalLabel">Edit Patokan Iuran</h4>
                                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                    <i data-feather="x"></i>
                                </button>
                            </div>

                            <form id="editMasterIuranForm" method="POST">
                                @csrf
                                @method('PUT')

                                <div class="modal-body">
                                    <label for="tahun">Tahun: </label>
                                    <div class="form-group">
                                        <input type="number" id="edit_tahun" name="tahun" placeholder="Tahun"
                                            class="form-control" readonly required>
                                    </div>

                                    <label for="edit_jumlah_patokan_tahunan">Jumlah Patokan (Rp): </label>
                                    <div class="form-group">
                                        <input type="text" id="jumlah_patokan_tahunan" name="jumlah_patokan_tahunan" placeholder="Jumlah Patokan"
                                            class="form-control" required>
                                        
                                    </div>

                                    <label for="edit_keterangan">Keterangan: </label>
                                    <div class="form-group">
                                        <input type="text" id="edit_keterangan" name="keterangan" placeholder="Keterangan (Opsional)"
                                            class="form-control"
                                            value="{{ old('keterangan') }}" required>
                                        
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-light-secondary" data-bs-dismiss="modal">
                                        <span class="d-none d-sm-block">Batal</span>
                                    </button>
                                    <button type="submit" class="btn btn-primary ml-1">
                                        <span class="d-none d-sm-block">Simpan Perubahan</span>
                                    </button>
                                </div>
                            </form>                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function () {
        
        // --- SCRIPT UNTUK MENGISI MODAL EDIT MASTER IURAN ---
        const editModal = document.getElementById('editMasterIuranModal');
        if (editModal) { // Pastikan modalnya ada
            editModal.addEventListener('show.bs.modal', event => {
                const button = event.relatedTarget; // Tombol edit yang diklik
                const id = button.getAttribute('data-id');
                const tahun = button.getAttribute('data-tahun');
                const jumlah = button.getAttribute('data-jumlah');
                const keterangan = button.getAttribute('data-keterangan');

                const form = editModal.querySelector('#editMasterIuranForm');
                const inputTahun = editModal.querySelector('#edit_tahun');
                const inputJumlah = editModal.querySelector('#edit_jumlah_patokan_tahunan');
                const inputKeterangan = editModal.querySelector('#edit_keterangan'); // Tambahkan ini

                // Atur action form
                form.action = `/master-iuran/${id}`; // Sesuaikan dengan nama route resource-mu

                // Isi nilai input
                inputTahun.value = tahun;
                inputJumlah.value = jumlah;
                inputKeterangan.value = keterangan; // Tambahkan ini
            });
        }
        const editForm = document.getElementById('editMasterIuranForm');
        editForm.addEventListener('submit', function(event) {
            event.preventDefault();

            const url = this.action;
            const formData = new FormData(this);

            fetch(url, {
                method: 'POST', 
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
                    'Accept': 'application/json',
                },
                body: formData
            })
            .then(async response => {
                if (response.ok) {
                    window.location.href = "{{ route('master-iuran.index') }}";
                } else {
                    const data = await response.json();
                    Swal.fire({
                        icon: 'error',
                        title: 'Gagal menyimpan!',
                        text: data.message || 'Cek kembali input Anda.'
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Oops...',
                    text: 'Tidak bisa terhubung ke server!'
                });
            });
        });
        // --- SCRIPT UNTUK MENANGANI SUBMIT FORM EDIT (jika pakai Fetch) ---
        // Jika kamu mau pakai Fetch API seperti di Sektor, tambahkan di sini
        // const editForm = document.getElementById('editMasterIuranForm');
        // if (editForm) {
        //     editForm.addEventListener('submit', function(event) {
        //         event.preventDefault();
        //         // ... kode fetch ...
        //     });
        // }

        // --- Script untuk modal tambah error ---
        @if($errors->any())
            // Cek apakah errornya dari form tambah atau edit
            // Jika ada cara membedakannya (misal, input _method ada di request),
            // buka modal yang sesuai. Untuk sementara, kita buka modal tambah.
            var myModal = new bootstrap.Modal(document.getElementById('tambahMasterIuranModal')); // Ganti ID jika perlu
            myModal.show();
        @endif

    });
</script>
@endpush