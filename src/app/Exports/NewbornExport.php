<?php

namespace App\Exports;

use App\Newborn;
use Maatwebsite\Excel\Concerns\FromCollection;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Maatwebsite\Excel\Events\BeforeSheet;
use Maatwebsite\Excel\Concerns\RegistersEventListeners;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;


class NewbornExport implements FromCollection, WithHeadings, WithEvents, ShouldAutoSize
{
	use RegistersEventListeners;

	/**
    * @return \array
    */
    public function registerEvents():array{
    	$styleArray = [
            'alignment' => [
               'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
            ],         
			'font' => [
				'bold' => true,
                'size' => 12,
			],

		];

    	return[

            BeforeSheet::class=>function(BeforeSheet $event) use ($styleArray){
                $event->sheet->setCellValue('A1', 'BITBO - Health Services Newborn')
                ->mergeCells('A1:N1')
                ->getStyle('A1:N1')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b7e280')
                ;
            },

    		AfterSheet::class => function(AfterSheet $event) use ($styleArray) {
    			$event->sheet->getStyle('A2:D2')
                ->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('f5db6a')
                ;

                $event->sheet->getStyle('E2:N2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('aacce8');


                $event->sheet->setCellValue('F'. ($event->sheet->getHighestRow('F')+2), 'Total # Newborn received Vaccination');
                $event->sheet->setCellValue('I'. ($event->sheet->getHighestRow('I')+2), '=COUNTIF(I2:I'.$event->sheet->getHighestRow('I').',"✓")');
                $event->sheet->setCellValue('J'. ($event->sheet->getHighestRow('J')+2), '=COUNTIF(J2:J'.$event->sheet->getHighestRow('J').',"✓")');
                $event->sheet->setCellValue('K'. ($event->sheet->getHighestRow('K')+2), '=COUNTIF(K2:K'.$event->sheet->getHighestRow('K').',"✓")');
                $event->sheet->setCellValue('L'. ($event->sheet->getHighestRow('L')+2), '=COUNTIF(L2:L'.$event->sheet->getHighestRow('L').',"✓")');
                $event->sheet->getStyle('F'.$event->sheet->getHighestRow('F'))->applyFromArray($styleArray);
                $event->sheet->getStyle('I'.$event->sheet->getHighestRow('I'))->applyFromArray($styleArray);
                $event->sheet->getStyle('J'.$event->sheet->getHighestRow('J'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('K'.$event->sheet->getHighestRow('K'))->applyFromArray($styleArray);
    		},
    	];
    	
    }


    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection(){


        $newborn2 = collect(DB::select('
             SELECT 
                CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.MIDDLENAME) AS FULLNAME
                ,H.HOUSEHOLD_ID
                ,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
                ,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
                ,DATE_OF_BIRTH
                ,NB.TYPE_OF_HOME_RECORD
                ,NB.BIRTH_WEIGHT
                ,NB.BIRTH_LENGTH
                ,IF (NB.HAD_BCG=1, "✓", "✗") AS BCG
                ,IF(NB.HAD_HEPA_B=1, "✓", "✗") AS HEPA_B
                ,IF(NB.HAD_NEWBORN_SCREENING=1, "✓", "✗") AS SCREENING
                ,IF(NB.HAD_BREASTFEED=1, "✓", "✗") AS BREASTFEED
                ,CONCAT(IF(NB.DO_A=1,"A",""), IF(NB.DO_B=1,"B",""), IF(NB.DO_C=1,"C",""), IF(NB.DO_D=1,"D",""), IF(NB.DO_E=1,"E",""), IF(NB.DO_F=1,"F",""),IF(NB.DO_A=0 AND NB.DO_B=0 AND NB.DO_C=0 AND NB.DO_D=0 AND NB.DO_E=0 AND NB.DO_F=0, "W","")) AS DANGER_OBSERVED
                ,NB.SOURCE_OF_SERVICE_RESERVED

            from t_hs_newborn AS NB
            INNER JOIN t_resident_basic_info as R
            ON R.RESIDENT_ID = NB.RESIDENT_ID
            INNER JOIN t_household_information AS H
            ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID  

            '));
    	return $newborn2;
    }

     /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		  'Buong Pangalan'
                ,'Household Number'
                ,'Kasarian'
                ,'Edad (Araw)'
                ,'Petsa ng Kapanganakan'
                ,'Klase ng Home Record'
                ,'Birth Weight'
                ,'Birth Length'
                ,'Nabigyan ng BGC' 
                ,'Nabigyan ng Hepa B'
                ,'Na Newborn Screening?'
                ,'Na Breastfeed Pagkapanganak' 
                ,'Panganib na naobserbahan' 
                ,'Pinanggalingan ng Serbisyong Natanggap'

    	];
    }

    


}
