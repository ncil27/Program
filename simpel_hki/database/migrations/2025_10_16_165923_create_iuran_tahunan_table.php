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

        Schema::create('iuran_tahunan', function (Blueprint $table) {
            $table->integer('id')->primary()->autoIncrement();
            $table->integer('id_keluarga');
            $table->foreign('id_keluarga')->references('id_keluarga')->on('keluarga');
            $table->year('tahun');
            $table->decimal('jumlah_terbayar', 15, 2);
            $table->date('tanggal_pembayaran_terakhir')->nullable();
            $table->text('keterangan')->nullable();
            $table->timestamp('updated_at')->nullable()->useCurrent();
            $table->unique(['id_keluarga', 'tahun']);
            $table->foreign('tahun')->references('tahun')->on('master_iuran');
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('iuran_tahunan');
    }
};
