<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class TOrdinance
 * 
 * @property int $ORDINANCE_ID
 * @property int $BARANGAY_OFFICIAL_ID
 * @property string $ORDINANCE_TITLE
 * @property int $ORDINANCE_CATEGORY_ID
 * @property string $ORDINANCE_DESCRIPTION
 * @property string $ORDINANCE_REMARKS
 * @property string $ORDINANCE_SANCTION
 * @property string $ORDINANCE_AUTHOR
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\ROrdinanceCategory $r_ordinance_category
 * @property \App\Models\TBarangayOfficial $t_barangay_official
 *
 * @package App\Models
 */
class TOrdinance extends Eloquent
{
	protected $table = 't_ordinance';
	protected $primaryKey = 'ORDINANCE_ID';
	public $timestamps = false;

	protected $casts = [
		'BARANGAY_OFFICIAL_ID' => 'int',
		'ORDINANCE_CATEGORY_ID' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'BARANGAY_OFFICIAL_ID',
		'ORDINANCE_TITLE',
		'ORDINANCE_CATEGORY_ID',
		'ORDINANCE_DESCRIPTION',
		'ORDINANCE_REMARKS',
		'ORDINANCE_SANCTION',
		'ORDINANCE_AUTHOR',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function r_ordinance_category()
	{
		return $this->belongsTo(\App\Models\ROrdinanceCategory::class, 'ORDINANCE_CATEGORY_ID');
	}

	public function t_barangay_official()
	{
		return $this->belongsTo(\App\Models\TBarangayOfficial::class, 'BARANGAY_OFFICIAL_ID');
	}
}
