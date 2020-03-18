<?php

namespace App\Imports;

use App\TOrdinance;
use Maatwebsite\Excel\Concerns\ToModel;
use DB;
class ResidentsImport implements ToModel
{
    /**
    * @param array $row
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        // DB::table('r_position')->insert([
        //         "POSITION_NAME" => $row[0]
        // ]);
        return $row[0];
    }
}
