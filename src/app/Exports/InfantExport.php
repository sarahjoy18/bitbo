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


class InfantExport implements FromCollection, WithHeadings, WithEvents, ShouldAutoSize
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
                ->mergeCells('A1:Z1')
                ->getStyle('A1:Z1')->applyFromArray($styleArray)
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

                $event->sheet->getStyle('E2:G2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('f7c376');

                 $event->sheet->getStyle('H2:I2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('aacce8');

                 $event->sheet->getStyle('J2:z2')->applyFromArray($styleArray)
                ->getFill()->setFillType(\PhpOffice\PhpSpreadsheet\Style\Fill::FILL_SOLID)
                ->getStartColor()->setARGB('f7c376');


                $event->sheet->setCellValue('F'. ($event->sheet->getHighestRow('F')+2), 'Total # Infant received Vaccination');
                $event->sheet->setCellValue('G'. ($event->sheet->getHighestRow('G')+2), '=COUNTIF(G2:G'.$event->sheet->getHighestRow('G').',"✓")');
                $event->sheet->setCellValue('H'. ($event->sheet->getHighestRow('H')+2), '=COUNTIF(H2:H'.$event->sheet->getHighestRow('H').',"✓")');
                $event->sheet->setCellValue('I'. ($event->sheet->getHighestRow('I')+2), '=COUNTIF(I2:I'.$event->sheet->getHighestRow('I').',"✓")');
                $event->sheet->setCellValue('J'. ($event->sheet->getHighestRow('J')+2), '=COUNTIF(J2:J'.$event->sheet->getHighestRow('J').',"✓")');
                $event->sheet->setCellValue('K'. ($event->sheet->getHighestRow('K')+2), '=COUNTIF(K2:K'.$event->sheet->getHighestRow('K').',"✓")');
                $event->sheet->setCellValue('L'. ($event->sheet->getHighestRow('L')+2), '=COUNTIF(L2:L'.$event->sheet->getHighestRow('L').',"✓")');
                $event->sheet->setCellValue('M'. ($event->sheet->getHighestRow('M')+2), '=COUNTIF(M2:M'.$event->sheet->getHighestRow('M').',"✓")');
                $event->sheet->setCellValue('N'. ($event->sheet->getHighestRow('N')+2), '=COUNTIF(N2:N'.$event->sheet->getHighestRow('N').',"✓")');
                $event->sheet->setCellValue('O'. ($event->sheet->getHighestRow('O')+2), '=COUNTIF(O2:O'.$event->sheet->getHighestRow('O').',"✓")');
                $event->sheet->setCellValue('P'. ($event->sheet->getHighestRow('P')+2), '=COUNTIF(P2:P'.$event->sheet->getHighestRow('P').',"✓")');
                $event->sheet->setCellValue('Q'. ($event->sheet->getHighestRow('Q')+2), '=COUNTIF(Q2:Q'.$event->sheet->getHighestRow('Q').',"✓")');
                $event->sheet->setCellValue('R'. ($event->sheet->getHighestRow('R')+2), '=COUNTIF(R2:R'.$event->sheet->getHighestRow('R').',"✓")');
                $event->sheet->setCellValue('S'. ($event->sheet->getHighestRow('S')+2), '=COUNTIF(S2:S'.$event->sheet->getHighestRow('S').',"✓")');
                $event->sheet->setCellValue('W'. ($event->sheet->getHighestRow('W')+2), '=COUNTIF(W2:W'.$event->sheet->getHighestRow('W').',"✓")');
                $event->sheet->setCellValue('X'. ($event->sheet->getHighestRow('X')+2), '=COUNTIF(X2:X'.$event->sheet->getHighestRow('X').',"✓")');

                $event->sheet->getStyle('F'.$event->sheet->getHighestRow('F'))->applyFromArray($styleArray);
                $event->sheet->getStyle('G'.$event->sheet->getHighestRow('G'))->applyFromArray($styleArray);
                $event->sheet->getStyle('H'.$event->sheet->getHighestRow('H'))->applyFromArray($styleArray);
                $event->sheet->getStyle('I'.$event->sheet->getHighestRow('I'))->applyFromArray($styleArray);
                $event->sheet->getStyle('J'.$event->sheet->getHighestRow('J'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('K'.$event->sheet->getHighestRow('K'))->applyFromArray($styleArray);
                $event->sheet->getStyle('L'.$event->sheet->getHighestRow('L'))->applyFromArray($styleArray);
                $event->sheet->getStyle('M'.$event->sheet->getHighestRow('M'))->applyFromArray($styleArray);
                $event->sheet->getStyle('N'.$event->sheet->getHighestRow('N'))->applyFromArray($styleArray);
                $event->sheet->getStyle('O'.$event->sheet->getHighestRow('O'))->applyFromArray($styleArray);
                $event->sheet->getStyle('P'.$event->sheet->getHighestRow('P'))->applyFromArray($styleArray);
                $event->sheet->getStyle('Q'.$event->sheet->getHighestRow('Q'))->applyFromArray($styleArray);
                $event->sheet->getStyle('R'.$event->sheet->getHighestRow('R'))->applyFromArray($styleArray);
                $event->sheet->getStyle('S'.$event->sheet->getHighestRow('S'))->applyFromArray($styleArray);
                $event->sheet->getStyle('W'.$event->sheet->getHighestRow('W'))->applyFromArray($styleArray);
                $event->sheet->getStyle('X'.$event->sheet->getHighestRow('X'))->applyFromArray($styleArray);
    		},
    	];
    	
    }

    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $infant = collect(DB::select('
        	SELECT 
                CONCAT(R.LASTNAME, ", ", R.FIRSTNAME, ", ", R.MIDDLENAME) AS FULLNAME
                ,H.HOUSEHOLD_ID
                ,IF(R.SEX="FEMALE", "Babae", "Lalaki") AS KASARIAN
                ,DATEDIFF(CURRENT_DATE, R.DATE_OF_BIRTH) AS  "AGE(days)"
                ,DATE_OF_BIRTH
								,I.TYPE_OF_HOME_RECORD
								,IF (I.HAD_BREASTFEED=1, "✓", "✗") AS HAD_BREASTFEED
								,IF (NB.HAD_BCG=1, "✓", "✗") AS BCG
								,IF (NB.HAD_HEPA_B=1, "✓", "✗") AS HEPA_B
								,IF (I.HAD_PENTA_1=1, "✓", "✗") AS PENTA_1
								,IF (I.HAD_PENTA_2=1, "✓", "✗") AS PENTA_2
								,IF (I.HAD_PENTA_3=1, "✓", "✗") AS PENTA_3
								,IF (I.HAD_OPV_1=1, "✓", "✗") AS OPV_1
								,IF (I.HAD_OPV_2=1, "✓", "✗") AS OPV_2
								,IF (I.HAD_OPV_3=1, "✓", "✗") AS OPV_3
								,IF (I.HAD_ROTA_1=1, "✓", "✗") AS ROTA_1
								,IF (I.HAD_ROTA_2=1, "✓", "✗") AS ROTA_2
								,IF (I.HAD_MEASLES=1, "✓", "✗") AS MEASLES
								,IF (I.HAD_VITAMIN_A=1, "✓", "✗") AS VITAMIN_A
								,I.OPT_DATE
								,I.OPT_WEIGHT
								,I.OPT_HEIGHT
								,IF (I.GP_APRIL_VIT_A=1, "✓", "✗") AS GP_APRIL
								,IF (I.GP_OCTOBER_VIT_A=1, "✓", "✗") AS GP_OCTOBER
                ,CONCAT(IF(I.DO_A=1,"A",""),IF(I.DO_B=1,"B",""),IF(I.DO_C=1,"C",""), IF(I.DO_D=1,"D",""), IF(I.DO_E=1,"E",""), IF(I.DO_F=1,"F",""), IF(I.DO_G=1,"G",""), IF(I.DO_H=1,"H",""), IF(I.DO_A=0 AND I.DO_B=0 AND I.DO_C=0 AND I.DO_D=0 AND I.DO_E=0 AND I.DO_F=0 AND I.DO_G=0 AND I.DO_H=0,"W","") 
								)AS DANGERS_OBSERVED
								,I.SOURCE_OF_SERVICE_RECEIVED

            from t_hs_newborn AS NB
            INNER JOIN t_resident_basic_info as R
            ON R.RESIDENT_ID = NB.RESIDENT_ID
            INNER JOIN t_household_information AS H
            ON H.HOUSEHOLD_ID = R.HOUSEHOLD_ID
						INNER JOIN t_hs_infant AS I
						ON I.NEW_BORN_ID = NB.NEWBORN_ID

        	'));

        return $infant;
    }

         /**
    * @return \Illuminate\Support\Collection
    */
    public function headings():array{
    	return [
    		 'Pangalan ng Infant'
				,'HH #'
				,'Kasarian'
				,'Edad'
				,'Petsa ng Kapanganakan'
				,'Klase ng Home-Based Record na mayroon ng UNINFANT'
				,'Nag-Breastfeed mula pagkapanganak?'
				,'Nabigyan ng BGC?'
				,'Nabigyan ng Hepa B?'
				,'Nabigyan ng Penta 1?'
				,'Nabigyan ng Penta 2?'
				,'Nabigyan ng Penta 3?'
				,'Nabigyan ng Penta OPV 1?'
				,'Nabigyan ng Penta OPV 2?'
				,'Nabigyan ng Penta OPV 3?'
				,'Nabigyan ng Penta Rota 1?'
				,'Nabigyan ng Penta Rota 2?'
				,'Nabigyan ng Measles?'
				,'Nabigyan ng Vitamin A?'
				,'Petsa ng pagkuha ng OPT'
				,'OPT Timbang (kg)'
				,'OPT Haba/Taas (kg)'
				,'GP-Vit A (Abril)'
				,'GP-Vit A (Oktubre)'
				,'Panganib na naobserbahan'
				,'Pinanggalingan ng Serbisyong Natanggap'
    	];
    }

}
