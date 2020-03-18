<?php

namespace App\Imports;

use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithStartRow;
class SampleImport implements ToModel,WithStartRow
{
    /**
    * @param Collection $collection
    */
    
    public function model(array $collection)
    {
        //
        echo $collection[0];
        
    }   
    public function startRow():int
    {
        return 5;
    }
}
