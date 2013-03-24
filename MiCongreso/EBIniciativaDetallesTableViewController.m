//
//  EBIniciativaDetallesTableViewController.m
//  MiCongreso
//
//  Created by Edu on 17/03/13.
//  Copyright (c) 2013 Eduardo Blancas. All rights reserved.
//

#import "EBIniciativaDetallesTableViewController.h"

#define kFontSize 15.0f
#define kTopMargin 10.0f
#define kBottomMargin 10.0f

@interface EBIniciativaDetallesTableViewController ()

@end

@implementation EBIniciativaDetallesTableViewController

@synthesize iniciativa;


-(void)didUpdateDetails{
    NSLog(@"Did update %d", iniciativa.localTotalVotos);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    iniciativa.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Detalles";
}

-(void)viewDidDisappear:(BOOL)animated{
    iniciativa.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 4:
            return [iniciativa.recursosAdicionales count];
        case 5:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                return 3;
            }else{
                return 1;
            }
        case 6:
            return 3;
        case 7:
            if(!didVote)
                return 2;
            else
                return 1;
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Fecha";
        case 1:
            return @"Propuesta por";
        case 2:
            return @"Descripción";
        case 3:
            return @"Estado de la iniciativa";
        case 4:
            return @"Recursos adicionales";
        case 5:
            return @"Votación oficial";
        case 6:
            return @"Votación en Curul501";
        case 7:
            return @"Vota la iniciativa en Curul501";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = iniciativa.fecha;
            break;
        case 1:
            if (iniciativa.nombreCongresista)
                cell.textLabel.text = iniciativa.nombreCongresista;
            else
                cell.textLabel.text = @"Información no disponible";
            break;
        case 2:
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.textLabel.numberOfLines = 10;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = iniciativa.descripcion;
            break;
        case 3:
            cell.textLabel.text = iniciativa.estado;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4:
            cell.textLabel.text = [[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"nombre"];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.textLabel.numberOfLines = 10;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 5:
            if (iniciativa.plenoAbstenciones && iniciativa.plenoAFavor && iniciativa.plenoEnContra) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos a favor: %d", iniciativa.plenoAFavor];
                        break;
                    case 1:
                        cell.textLabel.text = [NSString stringWithFormat:@"Votos en contra: %d", iniciativa.plenoEnContra];
                        break;
                    case 2:
                        cell.textLabel.text = [NSString stringWithFormat:@"Abstenciones: %d", iniciativa.plenoAbstenciones];
                        break;
                    default:
                        break;
                }
            }else{
                cell.textLabel.text = @"Esta iniciativa no ha sido votada";
            }
            
            break;
        case 6:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"Porcentaje a favor: %d%%", iniciativa.localAFavorPorcentaje];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"Porcentaje en contra: %d%%", iniciativa.localEnContraPorcentaje];
                    break;
                case 2:                
                    cell.textLabel.text = [NSString stringWithFormat:@"Número de votos: %d", iniciativa.localTotalVotos];
                    break;
                default:
                    break;
            }
            break;
        case 7:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            if (!didVote) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = @"Votar a favor";
                        break;
                    case 1:
                        cell.textLabel.text = @"Votar a en contra";
                    default:
                        break;
                }
            }else{
                cell.textLabel.text = @"¡Gracias por votar!";
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==2) {
        CGSize maxSize = CGSizeMake(280.0f, 200.0f);
        CGSize size = [iniciativa.descripcion sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+kTopMargin+kBottomMargin;
        
    }else if(indexPath.section==4){
        CGSize maxSize = CGSizeMake(250.0f, 200.0f);
        CGSize size = [[[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"nombre"] sizeWithFont:[UIFont boldSystemFontOfSize:kFontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
        return size.height+kTopMargin+kBottomMargin;
        
    }else{
        return 46.0f;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==7) {
        if (!didVote) {
            if (indexPath.row==0) {
                //Vote up
                [iniciativa voteUp];
            }else{
                //Vote down
                [iniciativa voteDown];
            }
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"¡Gracias!"
                                  message:@"Tu voto ha sido registrado"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            
            [alert show];
            didVote = YES;
            [iniciativa descargarDetalles];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:7] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Aviso"
                                  message:@"Ya has votado"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            
            [alert show];
        }
        
    }else if(indexPath.section==4){
        //Abrir Safari
        NSURL *url = [NSURL URLWithString:[[iniciativa.recursosAdicionales objectAtIndex:indexPath.row]objectForKey:@"url"]];
        [[UIApplication sharedApplication] openURL:url];
    }else if(indexPath.section==3){
        EBEstadoIniciativaViewController *controller = [[EBEstadoIniciativaViewController alloc]initWithStyle:UITableViewStyleGrouped];
        controller.estado = iniciativa.estado;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
