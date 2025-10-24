<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MasterIuran extends Model
{
    use HasFactory;

    protected $table = 'master_iuran';
    protected $fillable = [
        'tahun',
        'jumlah_patokan_tahunan',
        'keterangan',
    ];
    public $timestamps = true;
}
