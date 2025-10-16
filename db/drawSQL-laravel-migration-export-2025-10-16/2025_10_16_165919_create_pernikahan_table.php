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

        Schema::create('pernikahan', function (Blueprint $table) {
            $table->integer('id_pernikahan')->primary()->autoIncrement();
            $table->integer('id_jemaat_pria')->nullable();
            $table->foreign('id_jemaat_pria')->references('id_jemaat')->on('jemaat');
            $table->string('nama_pasangan_pria_luar', 255)->nullable();
            $table->integer('id_jemaat_wanita')->nullable();
            $table->foreign('id_jemaat_wanita')->references('id_jemaat')->on('jemaat');
            $table->string('nama_pasangan_wanita_luar', 255)->nullable();
            $table->date('tanggal_martumpol');
            $table->string('tempat_martumpol', 255)->nullable();
            $table->date('tanggal_pemberkatan');
            $table->string('tempat_pemberkatan', 255)->nullable();
            $table->string('no_surat_nikah', 100)->nullable();
            $table->integer('created_by')->nullable();
            $table->foreign('created_by')->references('id_user')->on('users');
            $table->timestamp('created_at')->nullable()->useCurrent();
        });

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pernikahan');
    }
};
