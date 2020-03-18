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


class PregnantExport implements FromCollection, WithHeadings, WithEvents, ShouldAutoSize
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
                ->mergeCells('A1:T1')
                ->getStyle('A1:T1')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b7e280');

                 $event->sheet
                ->mergeCells('A2:C2')
                ->getStyle('A2:C2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('8aca00');

                 $event->sheet
                ->mergeCells('D2:F2')
                ->getStyle('D2:F2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');


                $event->sheet->setCellValue('G2', 'Bilang ng Prenatal Checkup')
                ->mergeCells('G2:I2')
                ->getStyle('G2:I2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');

                 $event->sheet
                ->mergeCells('J2:K2')
                ->getStyle('J2:K2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');

                $event->sheet->setCellValue('L2', 'Nabigyan ng: ')
                ->mergeCells('L2:Q2')
                ->getStyle('L2:Q2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');

                 $event->sheet
                ->mergeCells('R2:T2')
                ->getStyle('R2:T2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');
            },

    		AfterSheet::class => function(AfterSheet $event) use ($styleArray) {

    			$event->sheet->getStyle('A3:C3')
                ->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('8aca00');

                $event->sheet->getStyle('D3:K3')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');

                 $event->sheet->getStyle('L3:Q3')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('4399b9');

                  $event->sheet->getStyle('R3:T3')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('b26475');


                 $event->sheet->setCellValue('K'. ($event->sheet->getHighestRow('F')+2), ' TOTAL # ');
                $event->sheet->setCellValue('L'. ($event->sheet->getHighestRow('L')+2), '=COUNTIF(L2:L'.$event->sheet->getHighestRow('L').',"✓")');
                $event->sheet->setCellValue('M'. ($event->sheet->getHighestRow('M')+2), '=COUNTIF(M2:M'.$event->sheet->getHighestRow('M').',"✓")');
                $event->sheet->setCellValue('N'. ($event->sheet->getHighestRow('N')+2), '=COUNTIF(N2:N'.$event->sheet->getHighestRow('N').',"✓")');
                $event->sheet->setCellValue('O'. ($event->sheet->getHighestRow('O')+2), '=COUNTIF(O2:O'.$event->sheet->getHighestRow('O').',"✓")');
                $event->sheet->setCellValue('P'. ($event->sheet->getHighestRow('P')+2), '=COUNTIF(P2:P'.$event->sheet->getHighestRow('P').',"✓")');
                $event->sheet->setCellValue('Q'. ($event->sheet->getHighestRow('Q')+2), '=COUNTIF(Q2:Q'.$event->sheet->getHighestRow('Q').',"✓")');

                 $event->sheet->getStyle('K'.$event->sheet->getHighestRow('K'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('M'.$event->sheet->getHighestRow('M'))->applyFromArray($styleArray);
                $event->sheet->getStyle('N'.$event->sheet->getHighestRow('N'))->applyFromArray($styleArray);
                $event->sheet->getStyle('O'.$event->sheet->getHighestRow('O'))->applyFromArray($styleArray);
                $event->sheet->getStyle('P'.$event->sheet->getHighestRow('P'))->applyFromArray($styleArray);
                $event->sheet->getStyle('Q'.$event->sheet->getHighestRow('Q'))->applyFromArray($styleArray);

               
    		},
    	];
    	
    }
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        //CHANGE
        $pregnant = collect(DB::select('
           SELECT 
					 CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.MIDDLENAME) AS FULLNAME
			     ,H.HOUSEHOLD_ID
					 ,TIMESTAMPDIFF(YEAR, R.DATE_OF_BIRTH, CURDATE()) AS "Age"
					 ,R.DATE_OF_BIRTH
					 ,P.TYPE_OF_HOME_RECORD
					 ,P.NUMBER_OF_MONTHS_PREGNANT
					 ,P.PRENATAL_CHECKUP_1TRI
					 ,P.PRENATAL_CHECKUP_2TRI
					 ,P.PRENATAL_CHECKUP_3TRI
					 ,P.HAD_BIRTH_PLAN
					 ,P.BLOOD_TYPE
					 , IF (P.HAD_FERRO_SULFATE_FOLIC_ACID=1, "✓", "✗") AS FSFA
					 , IF (P.HAD_TETANOUS_TOXOID_1=1, "✓", "✗") AS TT1
					 ,IF (P.HAD_TETANOUS_TOXOID_2 =1, "✓", "✗") AS TT2
					 , IF (P.HAD_TETANOUS_TOXOID_3=1, "✓", "✗") AS TT3
					 ,IF (P.HAD_TETANOUS_TOXOID_4 =1, "✓", "✗") AS TT4
					 ,IF (P.HAD_TETANOUS_TOXOID_5 =1, "✓", "✗") AS TT5
					 ,CONCAT(IF(P.DO_A=1,"A",""), IF(P.DO_B=1,"B",""), IF(P.DO_C=1,"C","") , IF(P.DO_D=1,"D",""), IF(P.DO_E=1,"E",""), IF(P.DO_F=1,"F",""), IF(P.DO_G=1,"G","")
					
											)AS DANGERS_OBSERVED
					 ,P.PREGNANCY_CONCLUSION
					 ,P.DUE_DATE
				
			FROM t_hs_pregnant AS P
			INNER JOIN t_resident_basic_info AS R
			ON R.RESIDENT_ID = P.RESIDENT_ID
			INNER JOIN t_household_information AS H
			ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID


            '));
    	return $pregnant;
    }


         /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		  'Pangalan'
				,'HH #'
				,'Edad '
				,'Petsa ng Kapanganakan'
				,'Klase ng Home-Based Record'
				,'Bilang ng buwan na buntis'
				,'1st tri'
				,'2nd tri'
				,'3rd tri'
				,'May birth plan?'
				,'Blood Type'
				,'Ferrous Sulfate with Folic Acid'
				,'Tetanus Toxoid 1'
				,'Tetanus Toxoid 2'
				,'Tetanus Toxoid 3'
				,'Tetanus Toxoid 4'
				,'Tetanus Toxoid 5'
				,'Panganib na naobserbahan'
				,'Kinahinatnan Pagka-panganak'
				,'Petsa ng panganganak'
    	];
    }
}
