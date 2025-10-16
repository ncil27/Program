<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::disableForeignKeyConstraints();

        Schema::create('transaksi_keuangan', function (Blueprint $table) {
            $table->integer('id_transaksi')->primary()->autoIncrement();
            $table->integer('id_kategori');
            $table->foreign('id_kategori')->references('id_kategori')->on('kategori_keuangan');
            $table->date('tanggal_transaksi');
            $table->text('keterangan');
            $table->decimal('jumlah', 15, 2);
            $table->integer('id_keluarga_pemberi')->nullable();
            $table->foreign('id_keluarga_pemberi')->references('id_keluarga')->on('keluarga');
            $table->foreignId('created_by')->nullable()->constrained('users');
            $table->timestamp('created_at')->nullable()->useCurrent();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaksi_keuangan');
    }
};
