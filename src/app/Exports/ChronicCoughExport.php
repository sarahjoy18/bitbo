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

class ChronicCoughExport implements FromCollection, WithHeadings, ShouldAutoSize, WithEvents
{
	use RegistersEventListeners;
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $chroniccough = collect(DB::select('
        	SELECT 
					CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.LASTNAME) AS FULLNAME
					,H.HOUSEHOLD_ID
					,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
					,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
					, IF (CC.HAD_MORE_THAN_2_WEEKS=1, "✓", "✗") AS HEPA_B
			FROM t_hs_chronic_cough AS CC
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = CC.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
			        	'));

         return $chroniccough;
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
				,'Umuubo ng dalawang linggo o higit pa?'
    	];
    }
}
