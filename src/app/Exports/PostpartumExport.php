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

class PostpartumExport implements  FromCollection, WithHeadings, WithEvents, ShouldAutoSize
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
                ->getStartColor()->setARGB('b7e280');

                 $event->sheet
                ->mergeCells('A2:C2')
                ->getStyle('A2:C2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('eae090');


                 $event->sheet
                ->mergeCells('D2:H2')
                ->getStyle('D2:H2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b5553d');

                 $event->sheet
                ->mergeCells('I2:K2')->setCellValue('I2', 'Bilang ng Postnatal Check-up')
                ->getStyle('I2:K2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b5553d');

                  $event->sheet
                ->mergeCells('L2:M2')->setCellValue('L2', 'Nabigyan ng:')
                ->getStyle('L2:M2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b5553d');
                 $event->sheet
                ->mergeCells('N2:O2')
                ->getStyle('N2:O2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b5553d');
                
            },

    		AfterSheet::class => function(AfterSheet $event) use ($styleArray) {

    			$event->sheet->getStyle('A3:C3')
                ->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('eae090');

                $event->sheet->getStyle('D3:O3')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');

                


               
    		},
    	];
    	
    }

    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $postpartum = collect(DB::select('
        		SELECT 
						 CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.MIDDLENAME) AS FULLNAME
				     ,H.HOUSEHOLD_ID
						 ,TIMESTAMPDIFF(YEAR, R.DATE_OF_BIRTH, CURDATE()) AS "Age"
						 ,PP.BIRH_DATE /**/
						 ,PP.BIRTH_PLACE
						 ,PP.BIRTH_COORDINATOR
						 ,CONCAT(IF(PP.DO_A=1,"A",""), IF(PP.DO_B=1,"B",""), IF(PP.DO_C=1,"C",""), IF(PP.DO_D=1,"D","")
												)AS DANGERS_OBSERVED
						 , /**/  IF (PP.HAD_BREASTFEED_1_HR=1, "✓", "✗")
						 ,PP.HAD_POSTNATAL_24_HRS
						 ,PP.HAD_POSTNATAL_72_HRS
						 ,PP.HAD_POSTNATAL_7_DAYS
						 ,  IF (PP.FERROUS_SULFATE=1, "✓", "✗") AS FFWFA/**/ 
						 ,IF (PP.VITAMIN_A  =1, "✓", "✗") AS VIT_A/**/
						 ,PP.SOURCE_OF_SERVICE_RECEIVED
						 , IF (PP.INTERESTED_IN_FP=1, "✓", "✗") AS INTERESTED_FP

					
				FROM t_hs_pregnant AS P
				INNER JOIN t_resident_basic_info AS R
				ON R.RESIDENT_ID = P.RESIDENT_ID
				INNER JOIN t_household_information AS H
				ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
				INNER JOIN t_hs_post_partum as PP
				ON P.PREGNANT_ID = PP.PREGNANT_ID
        	'));

        return $postpartum;
    }


    /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		  	'Pangalan'
				,'HH #'
				,'Edad'
				,'Bilang mula kapanganak (Araw)'
				,'Lugar kung saan nanganak'
				,'Sino ang nagpa-anak?'
				,'Panganib na naobserbahan'
				,'Nagpasuso sa loob ng 1 oras pagkapangannak'
				,'Unang 24 oras'
				,'Unang 72 oras'
				,'Unang 7 araw'
				,'Ferrous Sulfate with Folic Acid'
				,'Vitamin A'
				,'Pinanggalingan ng Serbisyo'
				,'Interesado mag-FP'

    	];
    }

}
