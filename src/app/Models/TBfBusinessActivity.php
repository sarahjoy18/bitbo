<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TBfBusinessActivity
 * 
 * @property int $BUSINESS_ACTIVITY_ID
 * @property int $LINE_OF_BUSINESS_ID
 * @property string $NO_OF_UNITS
 * @property string $CAPITALIZATION
 * @property string $GROSS_RECEIPTS_ESSENTIAL
 * @property string $GROSS_RECEIPTS_NON_ESSENTIAL
 * @property int $ISSUANCE_ID
 * 
 * @property \App\Models\TIssuance $t_issuance
 * @property \App\Models\RBfLineOfBusiness $r_bf_line_of_business
 *
 * @package App\Models
 */
class TBfBusinessActivity extends Eloquent
{
	protected $table = 't_bf_business_activity';
	protected $primaryKey = 'BUSINESS_ACTIVITY_ID';
	public $timestamps = false;

	protected $casts = [
		'LINE_OF_BUSINESS_ID' => 'int',
		'ISSUANCE_ID' => 'int'
	];

	protected $fillable = [
		'LINE_OF_BUSINESS_ID',
		'NO_OF_UNITS',
		'CAPITALIZATION',
		'GROSS_RECEIPTS_ESSENTIAL',
		'GROSS_RECEIPTS_NON_ESSENTIAL',
		'ISSUANCE_ID'
	];

	public function t_issuance()
	{
		return $this->belongsTo(\App\Models\TIssuance::class, 'ISSUANCE_ID');
	}

	public function r_bf_line_of_business()
	{
		return $this->belongsTo(\App\Models\RBfLineOfBusiness::class, 'LINE_OF_BUSINESS_ID');
	}
}
