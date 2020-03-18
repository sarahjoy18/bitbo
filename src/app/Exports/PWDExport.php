<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;


class PWDExport implements FromCollection, WithHeadings, ShouldAutoSize, WithEvents
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $pwd = collect(DB::select('
        	SELECT 
				CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
				,H.HOUSEHOLD_ID
				,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
				,TIMESTAMPDIFF(YEAR, R.DATE_OF_BIRTH, CURDATE()) AS "Age"
				,R.CIVIL_STATUS
				,PWD.DISABILITY
				,PWD.REASON_OF_DEATH
				,PWD.DATE_OF_DEATH
			FROM t_hs_pwd AS PWD
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = PWD.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
        	'));
        return $pwd;
    }

     /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		 'Pangalan'
				,'HH #'
				,'Kasarian'
				,'Edad'
				,'Estado Sibil'
				,'Uri ng Kapansanan'
				,'Dahilan Ng Pagkamatay'
				,'Petsa ng Pagkamatay'
    	];
    }
}
