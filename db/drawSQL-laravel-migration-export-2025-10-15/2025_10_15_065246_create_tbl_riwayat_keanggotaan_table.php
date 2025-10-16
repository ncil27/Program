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

        Schema::create('tbl_riwayat_keanggotaan', function (Blueprint $table) {
            $table->integer('id_riwayat')->primary()->autoIncrement();
            $table->integer('id_jemaat');
            $table->foreign('id_jemaat')->references('id_jemaat')->on('tbl_jemaat');
            $table->enum('jenis_event', ["Lahir","Baptis","Sidi","Pindah Keluar","Pindah Masuk","Meninggal"]);
            $table->date('tanggal_event');
            $table->text('keterangan')->nullable();
            $table->string('no_surat', 100)->nullable();
            $table->integer('created_by')->nullable();
            $table->foreign('created_by')->references('id_user')->on('tbl_users');
            $table->timestamp('created_at')->nullable()->useCurrent();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tbl_riwayat_keanggotaan');
    }
};
