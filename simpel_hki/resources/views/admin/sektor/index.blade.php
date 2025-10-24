@extends('layouts.app')

@section('header')
    <h2 class="font-semibold text-xl text-gray-800 leading-tight">
        {{ __('Manajemen Sektor') }}
    </h2>
@endsection
@section('content')
<div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900">
                    
                    <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#tambahSektorModal">Tambah Sektor</button>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Nama Sektor</th>
                                <th>Keterangan</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse ($sektors as $sektor)
                                <tr>
                                    <td>{{ $sektor->nama_sektor }}</td>
                                    <td>{{ $sektor->keterangan }}</td>
                                    <td>
                                        <button type="button" 
                                            class="btn btn-sm btn-primary btn-edit" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editSektorModal"
                                            data-id="{{ $sektor->id_sektor }}" 
                                            data-nama="{{ $sektor->nama_sektor }}" 
                                            data-keterangan="{{ $sektor->keterangan }}">EDIT</button>
                                        <!-- <form action="{{ route('sektor.destroy', $sektor->id_sektor) }}" method="POST" class="d-inline form-delete">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-danger">HAPUS</button>
                                        </form> -->
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="3" class="text-center">
                                        Data masih kosong.
                                    </td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                    <div class="modal fade text-left" id="tambahSektorModal" tabindex="-1" role="dialog" aria-labelledby="tambahSektorModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="tambahSektorModalLabel">Tambah Sektor Baru</h4>
                                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                        <i data-feather="x"></i>
                                    </button>
                                </div>

                                <form method="POST" action="{{ route('sektor.store') }}">
                                    @csrf
                                    <div class="modal-body">
                                        <label for="nama_sektor">Nama Sektor: </label>
                                        <div class="form-group">
                                            <input type="text" id="nama_sektor" name="nama_sektor" placeholder="Nama Sektor"
                                                class="form-control @error('nama_sektor') is-invalid @enderror" 
                                                value="{{ old('nama_sektor') }}" required>
                                            @error('nama_sektor')
                                                <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>

                                        <label for="keterangan">Keterangan: </label>
                                        <div class="form-group">
                                            <input type="text" id="keterangan" name="keterangan" placeholder="Keterangan"
                                                class="form-control @error('keterangan') is-invalid @enderror"
                                                value="{{ old('keterangan') }}" required>
                                            @error('keterangan')
                                                <div class="invalid-feedback">{{ $message }}</div>
                                            @enderror
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-light-secondary" data-bs-dismiss="modal">
                                            <span class="d-none d-sm-block">Batal</span>
                                        </button>
                                        <button type="submit" class="btn btn-primary ml-1">
                                            <span class="d-none d-sm-block">Simpan</span>
                                        </button>
                                    </div>
                                </form>
                                
                            </div> 
                        </div>
                    </div>
                    <div class="modal fade text-left" id="editSektorModal" tabindex="-1" role="dialog" aria-labelledby="editSektorModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="editSektorModalLabel">Edit Sektor</h4>
                                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                        <i data-feather="x"></i>
                                    </button>
                                </div>
                                
                                {{-- Action form akan diisi oleh JavaScript nanti --}}
                                <form id="editSektorForm" method="POST">
                                    @csrf
                                    @method('PUT') {{-- PENTING: Method untuk update --}}

                                    <div class="modal-body">
                                        <label for="edit_nama_sektor">Nama Sektor: </label>
                                        <div class="form-group">
                                            <input type="text" id="edit_nama_sektor" name="nama_sektor" placeholder="Nama Sektor"
                                                class="form-control" required>
                                        </div>

                                        <label for="edit_keterangan">Keterangan: </label>
                                        <div class="form-group">
                                            <input type="text" id="edit_keterangan" name="keterangan" placeholder="Keterangan"
                                                class="form-control" required>
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
        console.log('SweetAlert aktif!');
        document.querySelectorAll('.form-delete').forEach(form => {
            form.addEventListener('submit', function (event) {
                event.preventDefault();
                Swal.fire({
                    title: 'Apakah Anda yakin?',
                    text: "Data yang dihapus tidak dapat dikembalikan!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Ya, hapus!',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        this.submit();
                    }
                });
            });
        });
        const editSektorModal = document.getElementById('editSektorModal');
        editSektorModal.addEventListener('show.bs.modal', event => {
            
            const button = event.relatedTarget;

            
            const id = button.getAttribute('data-id');
            const nama = button.getAttribute('data-nama');
            const keterangan = button.getAttribute('data-keterangan');

            
            const form = editSektorModal.querySelector('#editSektorForm');
            const inputNama = editSektorModal.querySelector('#edit_nama_sektor');
            const inputKeterangan = editSektorModal.querySelector('#edit_keterangan');

            
            
            console.log({ id, nama, keterangan });

            form.action = `/sektor/${id}`;

            
            inputNama.value = nama;
            inputKeterangan.value = keterangan;
        });
        const editForm = document.getElementById('editSektorForm');
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
                    window.location.href = "{{ route('sektor.index') }}";
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

        @if($errors->any())
            var myModal = new bootstrap.Modal(document.getElementById('tambahSektorModal'));
            myModal.show();
        @endif
    </script>
@endpush